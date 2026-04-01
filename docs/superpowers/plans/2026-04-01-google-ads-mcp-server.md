# Google Ads MCP Server Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a custom Google Ads MCP server with 9 read tools, 11 write tools, and a draft-then-confirm safety architecture that prevents costly mistakes.

**Architecture:** Python MCP server using FastMCP (stdio transport) with synchronous Google Ads API calls inside async tool handlers. All write operations go through a three-gate safety system: session passphrase lock, draft-then-confirm with ChangePlans, and validate_only dry-runs before real mutations. Budget/bid inputs accept human currency only (never raw micros).

**Tech Stack:** Python 3.10+, `mcp[cli]` (official MCP SDK), `google-ads` v25+ (API v18), `pyyaml`, `python-dotenv`, `pytest`

---

## File Structure

All paths relative to `google-ads-mcp-server/` (sibling to `ad-platform-campaign-manager/`).

```
google-ads-mcp-server/
├── pyproject.toml                    # Project metadata, dependencies
├── config.yaml                       # Safety limits, write passphrase
├── config.example.yaml               # Template (committed, no secrets)
├── .env.example                      # Credential template
├── .gitignore                        # Python + secrets exclusions
│
├── google_ads_mcp/
│   ├── __init__.py                   # Package marker
│   ├── server.py                     # FastMCP entrypoint, registers all tools
│   ├── auth.py                       # GoogleAdsClient singleton from env/yaml
│   ├── config.py                     # Load + validate config.yaml safety settings
│   │
│   ├── tools/
│   │   ├── __init__.py
│   │   ├── read.py                   # 9 read-only MCP tools
│   │   ├── write.py                  # 11 write MCP tools (create ChangePlans only)
│   │   ├── confirm.py                # confirm_change + list_pending_plans tools
│   │   ├── write_lock.py            # Session lock state (is_unlocked, try_unlock, lock)
│   │   └── write_lock_tools.py      # MCP tools: unlock_writes / lock_writes / write_status
│   │
│   ├── safety/
│   │   ├── __init__.py
│   │   ├── plan_store.py            # In-memory ChangePlan store with TTL expiry
│   │   ├── validators.py            # Budget/bid caps, micros guard, stale-state check
│   │   └── audit_log.py            # JSON-lines logger to ~/google-ads-mcp-audit.jsonl
│   │
│   ├── models/
│   │   ├── __init__.py
│   │   └── change_plan.py          # ChangePlan dataclass
│   │
│   └── utils/
│       ├── __init__.py
│       ├── micros.py               # Human currency <-> micros with sanity checks
│       ├── gaql.py                 # GAQL date range validation
│       └── formatting.py          # Format API responses as readable strings
│
└── tests/
    ├── __init__.py
    ├── conftest.py                 # Shared fixtures: mock client, test config
    ├── test_micros.py
    ├── test_config.py
    ├── test_audit_log.py
    ├── test_change_plan.py
    ├── test_plan_store.py
    ├── test_validators.py
    ├── test_write_lock.py
    ├── test_read_tools.py
    ├── test_write_tools.py
    └── test_confirm.py
```

---

## Task 1: Project Scaffold

**Files:**
- Create: `pyproject.toml`
- Create: `config.yaml`
- Create: `config.example.yaml`
- Create: `.env.example`
- Create: `.gitignore`
- Create: all `__init__.py` files

- [ ] **Step 1: Create project directory and pyproject.toml**

```bash
mkdir -p ../google-ads-mcp-server
cd ../google-ads-mcp-server
```

```toml
# pyproject.toml
[project]
name = "google-ads-mcp-server"
version = "0.1.0"
description = "Google Ads MCP server with draft-then-confirm safety architecture"
requires-python = ">=3.10"
dependencies = [
    "mcp[cli]>=1.0.0",
    "google-ads>=25.0.0",
    "pyyaml>=6.0",
    "python-dotenv>=1.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "pytest-asyncio>=0.23",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

- [ ] **Step 2: Create .gitignore**

```gitignore
# .gitignore
__pycache__/
*.pyc
*.pyo
.venv/
venv/
*.egg-info/
dist/
build/
.env
config.yaml
google-ads.yaml
*.log
*.jsonl
.pytest_cache/
```

- [ ] **Step 3: Create .env.example**

```env
# .env.example
# Google Ads API credentials
GOOGLE_ADS_DEVELOPER_TOKEN=your-developer-token
GOOGLE_ADS_CLIENT_ID=your-oauth-client-id.apps.googleusercontent.com
GOOGLE_ADS_CLIENT_SECRET=your-oauth-client-secret
GOOGLE_ADS_REFRESH_TOKEN=your-refresh-token
GOOGLE_ADS_LOGIN_CUSTOMER_ID=1234567890
```

- [ ] **Step 4: Create config.yaml and config.example.yaml**

```yaml
# config.yaml (and config.example.yaml — identical except passphrase)
safety:
  write_enabled: true
  write_passphrase: "change-me-to-your-secret"
  max_budget_increase_pct: 50
  max_budget_decrease_pct: 50
  max_bid_increase_pct: 30
  max_bid_decrease_pct: 50
  plan_ttl_seconds: 300
  require_double_confirm_above_pct: 50
  blocked_operations:
    - REMOVE
  audit_log_path: "~/google-ads-mcp-audit.jsonl"

defaults:
  date_range: "LAST_30_DAYS"
  max_rows: 1000
```

- [ ] **Step 5: Create directory structure and __init__.py files**

```bash
mkdir -p google_ads_mcp/tools google_ads_mcp/safety google_ads_mcp/models google_ads_mcp/utils tests
```

Create empty `__init__.py` in: `google_ads_mcp/`, `google_ads_mcp/tools/`, `google_ads_mcp/safety/`, `google_ads_mcp/models/`, `google_ads_mcp/utils/`, `tests/`.

- [ ] **Step 6: Install dependencies**

```bash
python -m venv .venv
source .venv/bin/activate  # or .venv/Scripts/activate on Windows
pip install -e ".[dev]"
```

- [ ] **Step 7: Initialize git and commit scaffold**

```bash
git init
git add .
git commit -m "chore: scaffold google-ads-mcp-server project"
```

---

## Task 2: Micros Utility

**Files:**
- Create: `google_ads_mcp/utils/micros.py`
- Test: `tests/test_micros.py`

- [ ] **Step 1: Write failing tests**

```python
# tests/test_micros.py
from google_ads_mcp.utils.micros import currency_to_micros, micros_to_currency, validate_not_raw_micros


def test_currency_to_micros_whole_number():
    assert currency_to_micros(50.0) == 50_000_000


def test_currency_to_micros_cents():
    assert currency_to_micros(1.50) == 1_500_000


def test_currency_to_micros_zero():
    assert currency_to_micros(0.0) == 0


def test_micros_to_currency():
    assert micros_to_currency(50_000_000) == 50.0


def test_micros_to_currency_cents():
    assert micros_to_currency(1_500_000) == 1.5


def test_roundtrip():
    for amount in [0.01, 1.0, 50.0, 999.99, 10000.0]:
        assert micros_to_currency(currency_to_micros(amount)) == amount


def test_validate_not_raw_micros_rejects_large_values():
    error = validate_not_raw_micros(50_000_000)
    assert error is not None
    assert "micros" in error.lower()


def test_validate_not_raw_micros_rejects_above_threshold():
    error = validate_not_raw_micros(10_001)
    assert error is not None


def test_validate_not_raw_micros_accepts_normal_currency():
    assert validate_not_raw_micros(50.0) is None
    assert validate_not_raw_micros(999.99) is None
    assert validate_not_raw_micros(10_000.0) is None


def test_validate_not_raw_micros_accepts_zero():
    assert validate_not_raw_micros(0.0) is None


def test_currency_to_micros_negative_raises():
    try:
        currency_to_micros(-10.0)
        assert False, "Should have raised ValueError"
    except ValueError:
        pass
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_micros.py -v`
Expected: FAIL — `ModuleNotFoundError: No module named 'google_ads_mcp.utils.micros'`

- [ ] **Step 3: Implement micros.py**

```python
# google_ads_mcp/utils/micros.py
"""Currency <-> micros conversion with safety checks.

Google Ads API uses micros: 1,000,000 micros = 1 unit of currency.
Example: 50.00 EUR = 50,000,000 micros.
"""

MICROS_PER_UNIT = 1_000_000
RAW_MICROS_THRESHOLD = 10_000


def currency_to_micros(amount: float) -> int:
    """Convert human currency (e.g., 50.00) to micros (50,000,000).

    Args:
        amount: Currency amount (e.g., 50.00 for fifty euros).

    Returns:
        Integer micros value.

    Raises:
        ValueError: If amount is negative.
    """
    if amount < 0:
        raise ValueError(f"Currency amount cannot be negative: {amount}")
    return int(round(amount * MICROS_PER_UNIT))


def micros_to_currency(micros: int) -> float:
    """Convert micros (50,000,000) to human currency (50.0)."""
    return round(micros / MICROS_PER_UNIT, 2)


def validate_not_raw_micros(value: float) -> str | None:
    """Check if a value looks like raw micros instead of currency.

    Returns None if the value looks like normal currency.
    Returns an error message if it looks like someone passed raw micros.
    """
    if value > RAW_MICROS_THRESHOLD:
        return (
            f"Value {value:,.0f} looks like raw micros, not currency. "
            f"This server accepts human currency (e.g., 50.00 for fifty euros). "
            f"If you meant {micros_to_currency(int(value)):.2f}, pass that instead."
        )
    return None
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `pytest tests/test_micros.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/utils/micros.py tests/test_micros.py
git commit -m "feat: add micros utility with currency conversion and safety guard"
```

---

## Task 3: Config Module

**Files:**
- Create: `google_ads_mcp/config.py`
- Test: `tests/test_config.py`

- [ ] **Step 1: Write failing tests**

```python
# tests/test_config.py
import os
import tempfile
import yaml
from google_ads_mcp.config import load_config, SafetyConfig, AppConfig


def _write_config(tmp_path: str, data: dict) -> str:
    path = os.path.join(tmp_path, "config.yaml")
    with open(path, "w") as f:
        yaml.dump(data, f)
    return path


def test_load_config_defaults(tmp_path):
    path = _write_config(str(tmp_path), {})
    config = load_config(path)
    assert config.safety.max_budget_increase_pct == 50
    assert config.safety.max_bid_increase_pct == 30
    assert config.safety.plan_ttl_seconds == 300
    assert config.safety.write_enabled is True
    assert "REMOVE" in config.safety.blocked_operations


def test_load_config_custom_values(tmp_path):
    path = _write_config(str(tmp_path), {
        "safety": {
            "max_budget_increase_pct": 25,
            "write_passphrase": "my-secret",
            "blocked_operations": ["REMOVE", "CREATE"],
        }
    })
    config = load_config(path)
    assert config.safety.max_budget_increase_pct == 25
    assert config.safety.write_passphrase == "my-secret"
    assert "CREATE" in config.safety.blocked_operations


def test_load_config_missing_file():
    config = load_config("/nonexistent/path/config.yaml")
    assert config.safety.max_budget_increase_pct == 50


def test_safety_config_has_passphrase():
    config = SafetyConfig(write_passphrase="test-pass")
    assert config.write_passphrase == "test-pass"
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_config.py -v`
Expected: FAIL — `ModuleNotFoundError`

- [ ] **Step 3: Implement config.py**

```python
# google_ads_mcp/config.py
"""Load and validate safety configuration from config.yaml."""

import os
from dataclasses import dataclass, field
from pathlib import Path

import yaml


@dataclass
class SafetyConfig:
    write_enabled: bool = True
    write_passphrase: str = ""
    max_budget_increase_pct: int = 50
    max_budget_decrease_pct: int = 50
    max_bid_increase_pct: int = 30
    max_bid_decrease_pct: int = 50
    plan_ttl_seconds: int = 300
    require_double_confirm_above_pct: int = 50
    blocked_operations: list[str] = field(default_factory=lambda: ["REMOVE"])
    audit_log_path: str = "~/google-ads-mcp-audit.jsonl"


@dataclass
class DefaultsConfig:
    date_range: str = "LAST_30_DAYS"
    max_rows: int = 1000


@dataclass
class AppConfig:
    safety: SafetyConfig = field(default_factory=SafetyConfig)
    defaults: DefaultsConfig = field(default_factory=DefaultsConfig)


def load_config(path: str | None = None) -> AppConfig:
    """Load config from yaml file. Returns defaults if file missing."""
    if path is None:
        path = os.path.join(os.path.dirname(__file__), "..", "config.yaml")
        path = str(Path(path).resolve())

    raw = {}
    if os.path.exists(path):
        with open(path) as f:
            raw = yaml.safe_load(f) or {}

    safety_raw = raw.get("safety", {})
    defaults_raw = raw.get("defaults", {})

    safety = SafetyConfig(**{
        k: v for k, v in safety_raw.items()
        if k in SafetyConfig.__dataclass_fields__
    })
    defaults = DefaultsConfig(**{
        k: v for k, v in defaults_raw.items()
        if k in DefaultsConfig.__dataclass_fields__
    })

    return AppConfig(safety=safety, defaults=defaults)


_config: AppConfig | None = None


def get_config(path: str | None = None) -> AppConfig:
    """Get or load the singleton config."""
    global _config
    if _config is None:
        _config = load_config(path)
    return _config


def reset_config():
    """Reset singleton (for testing)."""
    global _config
    _config = None
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `pytest tests/test_config.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/config.py tests/test_config.py
git commit -m "feat: add config module with safety settings and defaults"
```

---

## Task 4: Auth Module

**Files:**
- Create: `google_ads_mcp/auth.py`
- Test: `tests/test_auth.py` (minimal — real auth needs credentials)

- [ ] **Step 1: Write failing test**

```python
# tests/test_auth.py
import os
from unittest.mock import patch, MagicMock
from google_ads_mcp.auth import get_client, reset_client


def test_get_client_from_yaml(tmp_path):
    """Test that get_client tries yaml first."""
    yaml_path = str(tmp_path / "google-ads.yaml")
    with open(yaml_path, "w") as f:
        f.write("developer_token: test\n")

    with patch("google_ads_mcp.auth.GoogleAdsClient") as mock_cls:
        mock_cls.load_from_storage.return_value = MagicMock()
        reset_client()
        client = get_client(yaml_path=yaml_path)
        mock_cls.load_from_storage.assert_called_once_with(path=yaml_path, version="v18")
        assert client is not None


def test_get_client_from_env():
    """Test that get_client falls back to env vars."""
    with patch("google_ads_mcp.auth.GoogleAdsClient") as mock_cls:
        mock_cls.load_from_env.return_value = MagicMock()
        reset_client()
        client = get_client(yaml_path="/nonexistent/path.yaml")
        mock_cls.load_from_env.assert_called_once()
        assert client is not None


def test_get_client_singleton():
    """Test that get_client returns same instance on repeated calls."""
    with patch("google_ads_mcp.auth.GoogleAdsClient") as mock_cls:
        mock_cls.load_from_env.return_value = MagicMock()
        reset_client()
        client1 = get_client(yaml_path="/nonexistent")
        client2 = get_client(yaml_path="/nonexistent")
        assert client1 is client2


def test_get_client_raises_on_failure():
    """Test clear error when no credentials available."""
    with patch("google_ads_mcp.auth.GoogleAdsClient") as mock_cls:
        mock_cls.load_from_env.side_effect = Exception("No credentials")
        reset_client()
        try:
            get_client(yaml_path="/nonexistent")
            assert False, "Should have raised"
        except RuntimeError as e:
            assert "credentials" in str(e).lower()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_auth.py -v`
Expected: FAIL

- [ ] **Step 3: Implement auth.py**

```python
# google_ads_mcp/auth.py
"""Google Ads client initialization.

Tries google-ads.yaml first, falls back to environment variables.
Returns a singleton GoogleAdsClient instance.
"""

import os
from pathlib import Path

from google.ads.googleads.client import GoogleAdsClient


_client: GoogleAdsClient | None = None

API_VERSION = "v18"


def get_client(yaml_path: str | None = None) -> GoogleAdsClient:
    """Get or create the Google Ads client singleton.

    Load order:
    1. google-ads.yaml at yaml_path (or ~/google-ads.yaml)
    2. Environment variables (GOOGLE_ADS_DEVELOPER_TOKEN, etc.)

    Raises:
        RuntimeError: If no valid credentials found.
    """
    global _client
    if _client is not None:
        return _client

    if yaml_path is None:
        yaml_path = str(Path.home() / "google-ads.yaml")

    # Try yaml file first
    if os.path.exists(yaml_path):
        _client = GoogleAdsClient.load_from_storage(path=yaml_path, version=API_VERSION)
        return _client

    # Fall back to environment variables
    try:
        _client = GoogleAdsClient.load_from_env(version=API_VERSION)
        return _client
    except Exception as e:
        raise RuntimeError(
            f"Could not load Google Ads credentials. "
            f"Place google-ads.yaml in your home directory, "
            f"or set GOOGLE_ADS_DEVELOPER_TOKEN and related env vars. "
            f"Original error: {e}"
        )


def reset_client():
    """Reset the singleton (for testing)."""
    global _client
    _client = None
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `pytest tests/test_auth.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/auth.py tests/test_auth.py
git commit -m "feat: add auth module with yaml/env credential loading"
```

---

## Task 5: Audit Log

**Files:**
- Create: `google_ads_mcp/safety/audit_log.py`
- Test: `tests/test_audit_log.py`

- [ ] **Step 1: Write failing tests**

```python
# tests/test_audit_log.py
import json
import os
import tempfile
from google_ads_mcp.safety.audit_log import AuditLogger


def test_log_read_operation(tmp_path):
    log_path = str(tmp_path / "audit.jsonl")
    logger = AuditLogger(log_path)
    logger.log_read("list_campaigns", "1234567890", "SELECT ...", 5, 120)

    with open(log_path) as f:
        line = json.loads(f.readline())

    assert line["tool"] == "list_campaigns"
    assert line["customer_id"] == "1234567890"
    assert line["query"] == "SELECT ..."
    assert line["row_count"] == 5
    assert line["duration_ms"] == 120
    assert line["type"] == "read"
    assert "timestamp" in line


def test_log_write_operation(tmp_path):
    log_path = str(tmp_path / "audit.jsonl")
    logger = AuditLogger(log_path)
    logger.log_write(
        tool="update_budget",
        customer_id="1234567890",
        resource_name="customers/123/campaigns/456",
        plan_id="abc-123",
        old_value="50.00",
        new_value="75.00",
        result="success",
        error=None,
        duration_ms=200,
    )

    with open(log_path) as f:
        line = json.loads(f.readline())

    assert line["tool"] == "update_budget"
    assert line["plan_id"] == "abc-123"
    assert line["old_value"] == "50.00"
    assert line["new_value"] == "75.00"
    assert line["result"] == "success"
    assert line["type"] == "write"


def test_log_appends_multiple_entries(tmp_path):
    log_path = str(tmp_path / "audit.jsonl")
    logger = AuditLogger(log_path)
    logger.log_read("tool1", "123", "q1", 1, 10)
    logger.log_read("tool2", "456", "q2", 2, 20)

    with open(log_path) as f:
        lines = f.readlines()

    assert len(lines) == 2
    assert json.loads(lines[0])["tool"] == "tool1"
    assert json.loads(lines[1])["tool"] == "tool2"
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_audit_log.py -v`
Expected: FAIL

- [ ] **Step 3: Implement audit_log.py**

```python
# google_ads_mcp/safety/audit_log.py
"""JSON-lines audit logger for all MCP operations."""

import json
import os
from datetime import datetime, timezone
from pathlib import Path


class AuditLogger:
    def __init__(self, log_path: str | None = None):
        if log_path is None:
            log_path = "~/google-ads-mcp-audit.jsonl"
        self.log_path = str(Path(os.path.expanduser(log_path)).resolve())

    def _write(self, entry: dict):
        entry["timestamp"] = datetime.now(timezone.utc).isoformat()
        os.makedirs(os.path.dirname(self.log_path), exist_ok=True)
        with open(self.log_path, "a") as f:
            f.write(json.dumps(entry) + "\n")

    def log_read(
        self,
        tool: str,
        customer_id: str,
        query: str,
        row_count: int,
        duration_ms: int,
    ):
        self._write({
            "type": "read",
            "tool": tool,
            "customer_id": customer_id,
            "query": query,
            "row_count": row_count,
            "duration_ms": duration_ms,
        })

    def log_write(
        self,
        tool: str,
        customer_id: str,
        resource_name: str,
        plan_id: str,
        old_value: str,
        new_value: str,
        result: str,
        error: str | None,
        duration_ms: int,
    ):
        self._write({
            "type": "write",
            "tool": tool,
            "customer_id": customer_id,
            "resource_name": resource_name,
            "plan_id": plan_id,
            "old_value": old_value,
            "new_value": new_value,
            "result": result,
            "error": error,
            "duration_ms": duration_ms,
        })
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `pytest tests/test_audit_log.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/safety/audit_log.py tests/test_audit_log.py
git commit -m "feat: add JSON-lines audit logger for all operations"
```

---

## Task 6: ChangePlan Model and Plan Store

**Files:**
- Create: `google_ads_mcp/models/change_plan.py`
- Create: `google_ads_mcp/safety/plan_store.py`
- Test: `tests/test_change_plan.py`
- Test: `tests/test_plan_store.py`

- [ ] **Step 1: Write failing tests for ChangePlan**

```python
# tests/test_change_plan.py
from datetime import datetime, timezone, timedelta
from google_ads_mcp.models.change_plan import ChangePlan, create_plan


def test_create_plan_generates_id():
    plan = create_plan(
        tool_name="pause_campaign",
        customer_id="123",
        resource_name="customers/123/campaigns/456",
        entity_type="campaign",
        entity_name="Brand - NL",
        field="status",
        old_value="ENABLED",
        new_value="PAUSED",
        old_display="ENABLED",
        new_display="PAUSED",
        ttl_seconds=300,
    )
    assert plan.plan_id is not None
    assert len(plan.plan_id) > 0


def test_create_plan_sets_expiry():
    plan = create_plan(
        tool_name="pause_campaign",
        customer_id="123",
        resource_name="customers/123/campaigns/456",
        entity_type="campaign",
        entity_name="Brand - NL",
        field="status",
        old_value="ENABLED",
        new_value="PAUSED",
        old_display="ENABLED",
        new_display="PAUSED",
        ttl_seconds=300,
    )
    assert plan.expires_at > plan.created_at
    diff = (plan.expires_at - plan.created_at).total_seconds()
    assert 299 <= diff <= 301


def test_plan_is_expired():
    plan = create_plan(
        tool_name="test",
        customer_id="123",
        resource_name="r",
        entity_type="campaign",
        entity_name="Test",
        field="status",
        old_value="A",
        new_value="B",
        old_display="A",
        new_display="B",
        ttl_seconds=0,
    )
    assert plan.is_expired()


def test_plan_not_expired():
    plan = create_plan(
        tool_name="test",
        customer_id="123",
        resource_name="r",
        entity_type="campaign",
        entity_name="Test",
        field="status",
        old_value="A",
        new_value="B",
        old_display="A",
        new_display="B",
        ttl_seconds=300,
    )
    assert not plan.is_expired()


def test_plan_format_description():
    plan = create_plan(
        tool_name="update_budget",
        customer_id="123",
        resource_name="customers/123/campaigns/456",
        entity_type="campaign",
        entity_name="Brand - NL",
        field="budget",
        old_value="50000000",
        new_value="75000000",
        old_display="50.00 EUR/day",
        new_display="75.00 EUR/day",
        ttl_seconds=300,
        needs_double_confirm=True,
        double_confirm_reason="Budget increase exceeds 50%",
    )
    desc = plan.format_description()
    assert "Brand - NL" in desc
    assert "50.00 EUR/day" in desc
    assert "75.00 EUR/day" in desc
    assert plan.plan_id in desc
    assert "double confirm" in desc.lower() or "force" in desc.lower()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_change_plan.py -v`
Expected: FAIL

- [ ] **Step 3: Implement change_plan.py**

```python
# google_ads_mcp/models/change_plan.py
"""ChangePlan model for draft-then-confirm write operations."""

import uuid
from dataclasses import dataclass, field
from datetime import datetime, timezone, timedelta
from typing import Any


@dataclass
class ChangePlan:
    plan_id: str
    tool_name: str
    customer_id: str
    resource_name: str
    entity_type: str
    entity_name: str
    field: str
    old_value: Any
    new_value: Any
    old_display: str
    new_display: str
    created_at: datetime
    expires_at: datetime
    needs_double_confirm: bool = False
    double_confirm_reason: str | None = None

    def is_expired(self) -> bool:
        return datetime.now(timezone.utc) >= self.expires_at

    def format_description(self) -> str:
        lines = [
            "PROPOSED CHANGE (not yet applied)",
            f"Plan ID: {self.plan_id}",
            f"{self.entity_type.title()}: {self.entity_name} (customer {self.customer_id})",
            f"Change: {self.field} {self.old_display} -> {self.new_display}",
        ]
        if self.needs_double_confirm:
            lines.append(f"WARNING: {self.double_confirm_reason}")
            lines.append(f"To apply: call confirm_change(plan_id=\"{self.plan_id}\", force=true)")
        else:
            lines.append(f"To apply: call confirm_change(plan_id=\"{self.plan_id}\")")

        ttl = int((self.expires_at - datetime.now(timezone.utc)).total_seconds())
        if ttl > 0:
            lines.append(f"This plan expires in {ttl} seconds.")
        return "\n".join(lines)


def create_plan(
    tool_name: str,
    customer_id: str,
    resource_name: str,
    entity_type: str,
    entity_name: str,
    field: str,
    old_value: Any,
    new_value: Any,
    old_display: str,
    new_display: str,
    ttl_seconds: int,
    needs_double_confirm: bool = False,
    double_confirm_reason: str | None = None,
) -> ChangePlan:
    now = datetime.now(timezone.utc)
    return ChangePlan(
        plan_id=str(uuid.uuid4())[:8],
        tool_name=tool_name,
        customer_id=customer_id,
        resource_name=resource_name,
        entity_type=entity_type,
        entity_name=entity_name,
        field=field,
        old_value=old_value,
        new_value=new_value,
        old_display=old_display,
        new_display=new_display,
        created_at=now,
        expires_at=now + timedelta(seconds=ttl_seconds),
        needs_double_confirm=needs_double_confirm,
        double_confirm_reason=double_confirm_reason,
    )
```

- [ ] **Step 4: Run ChangePlan tests**

Run: `pytest tests/test_change_plan.py -v`
Expected: All PASS

- [ ] **Step 5: Write failing tests for PlanStore**

```python
# tests/test_plan_store.py
from google_ads_mcp.safety.plan_store import PlanStore
from google_ads_mcp.models.change_plan import create_plan


def _make_plan(ttl: int = 300) -> "ChangePlan":
    return create_plan(
        tool_name="pause_campaign",
        customer_id="123",
        resource_name="customers/123/campaigns/456",
        entity_type="campaign",
        entity_name="Test",
        field="status",
        old_value="ENABLED",
        new_value="PAUSED",
        old_display="ENABLED",
        new_display="PAUSED",
        ttl_seconds=ttl,
    )


def test_store_and_retrieve():
    store = PlanStore()
    plan = _make_plan()
    store.add(plan)
    retrieved = store.get(plan.plan_id)
    assert retrieved is not None
    assert retrieved.plan_id == plan.plan_id


def test_retrieve_nonexistent():
    store = PlanStore()
    assert store.get("nonexistent") is None


def test_retrieve_expired():
    store = PlanStore()
    plan = _make_plan(ttl=0)
    store.add(plan)
    assert store.get(plan.plan_id) is None


def test_remove():
    store = PlanStore()
    plan = _make_plan()
    store.add(plan)
    store.remove(plan.plan_id)
    assert store.get(plan.plan_id) is None


def test_list_pending():
    store = PlanStore()
    plan1 = _make_plan()
    plan2 = _make_plan()
    expired = _make_plan(ttl=0)
    store.add(plan1)
    store.add(plan2)
    store.add(expired)
    pending = store.list_pending()
    assert len(pending) == 2
    ids = {p.plan_id for p in pending}
    assert plan1.plan_id in ids
    assert plan2.plan_id in ids


def test_prune_expired():
    store = PlanStore()
    active = _make_plan(ttl=300)
    expired = _make_plan(ttl=0)
    store.add(active)
    store.add(expired)
    store.prune()
    assert len(store.list_pending()) == 1
```

- [ ] **Step 6: Run PlanStore tests to verify they fail**

Run: `pytest tests/test_plan_store.py -v`
Expected: FAIL

- [ ] **Step 7: Implement plan_store.py**

```python
# google_ads_mcp/safety/plan_store.py
"""In-memory store for pending ChangePlans with TTL expiry."""

from google_ads_mcp.models.change_plan import ChangePlan


class PlanStore:
    def __init__(self):
        self._plans: dict[str, ChangePlan] = {}

    def add(self, plan: ChangePlan):
        self._plans[plan.plan_id] = plan

    def get(self, plan_id: str) -> ChangePlan | None:
        plan = self._plans.get(plan_id)
        if plan is None:
            return None
        if plan.is_expired():
            del self._plans[plan_id]
            return None
        return plan

    def remove(self, plan_id: str):
        self._plans.pop(plan_id, None)

    def list_pending(self) -> list[ChangePlan]:
        self.prune()
        return list(self._plans.values())

    def prune(self):
        expired = [pid for pid, p in self._plans.items() if p.is_expired()]
        for pid in expired:
            del self._plans[pid]
```

- [ ] **Step 8: Run all tests for this task**

Run: `pytest tests/test_change_plan.py tests/test_plan_store.py -v`
Expected: All PASS

- [ ] **Step 9: Commit**

```bash
git add google_ads_mcp/models/change_plan.py google_ads_mcp/safety/plan_store.py tests/test_change_plan.py tests/test_plan_store.py
git commit -m "feat: add ChangePlan model and in-memory plan store with TTL"
```

---

## Task 7: Validators

**Files:**
- Create: `google_ads_mcp/safety/validators.py`
- Test: `tests/test_validators.py`

- [ ] **Step 1: Write failing tests**

```python
# tests/test_validators.py
from google_ads_mcp.safety.validators import (
    validate_budget_change,
    validate_bid_change,
    validate_not_blocked,
    validate_state_not_stale,
)
from google_ads_mcp.config import SafetyConfig


def _config(**overrides) -> SafetyConfig:
    defaults = {
        "max_budget_increase_pct": 50,
        "max_budget_decrease_pct": 50,
        "max_bid_increase_pct": 30,
        "max_bid_decrease_pct": 50,
        "require_double_confirm_above_pct": 50,
        "blocked_operations": ["REMOVE"],
    }
    defaults.update(overrides)
    return SafetyConfig(**defaults)


# --- Budget validation ---

def test_budget_increase_within_cap():
    result = validate_budget_change(50_000_000, 70_000_000, _config())
    assert result.is_valid
    assert not result.needs_double_confirm


def test_budget_increase_at_cap():
    # 50 -> 75 = exactly 50%
    result = validate_budget_change(50_000_000, 75_000_000, _config())
    assert result.is_valid
    assert result.needs_double_confirm


def test_budget_increase_exceeds_cap():
    # 50 -> 80 = 60% increase
    result = validate_budget_change(50_000_000, 80_000_000, _config())
    assert not result.is_valid
    assert "60" in result.message or "exceeds" in result.message.lower()


def test_budget_decrease_within_cap():
    result = validate_budget_change(50_000_000, 30_000_000, _config())
    assert result.is_valid


def test_budget_decrease_exceeds_cap():
    # 50 -> 20 = 60% decrease
    result = validate_budget_change(50_000_000, 20_000_000, _config())
    assert not result.is_valid


def test_budget_no_change():
    result = validate_budget_change(50_000_000, 50_000_000, _config())
    assert result.is_valid
    assert not result.needs_double_confirm


def test_budget_from_zero():
    result = validate_budget_change(0, 50_000_000, _config())
    assert result.is_valid


# --- Bid validation ---

def test_bid_increase_within_cap():
    result = validate_bid_change(1_000_000, 1_200_000, _config())
    assert result.is_valid


def test_bid_increase_exceeds_cap():
    # 1.00 -> 1.40 = 40% increase, cap is 30%
    result = validate_bid_change(1_000_000, 1_400_000, _config())
    assert not result.is_valid


# --- Blocked operations ---

def test_remove_blocked():
    result = validate_not_blocked("REMOVE", _config())
    assert not result.is_valid
    assert "blocked" in result.message.lower()


def test_pause_not_blocked():
    result = validate_not_blocked("PAUSE", _config())
    assert result.is_valid


# --- Stale state ---

def test_stale_state_matches():
    result = validate_state_not_stale("ENABLED", "ENABLED")
    assert result.is_valid


def test_stale_state_changed():
    result = validate_state_not_stale("ENABLED", "PAUSED")
    assert not result.is_valid
    assert "changed" in result.message.lower() or "stale" in result.message.lower()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_validators.py -v`
Expected: FAIL

- [ ] **Step 3: Implement validators.py**

```python
# google_ads_mcp/safety/validators.py
"""Safety validators for budget/bid caps, blocked operations, and stale state."""

from dataclasses import dataclass
from google_ads_mcp.config import SafetyConfig


@dataclass
class ValidationResult:
    is_valid: bool
    needs_double_confirm: bool = False
    message: str = ""


def validate_budget_change(
    current_micros: int,
    proposed_micros: int,
    config: SafetyConfig,
) -> ValidationResult:
    """Validate a budget change against configured caps."""
    if current_micros == 0:
        return ValidationResult(is_valid=True, message="New budget from zero.")

    if proposed_micros == current_micros:
        return ValidationResult(is_valid=True, message="No change.")

    change_pct = ((proposed_micros - current_micros) / current_micros) * 100

    if change_pct > 0:
        if change_pct > config.max_budget_increase_pct:
            return ValidationResult(
                is_valid=False,
                message=(
                    f"Budget increase of {change_pct:.0f}% exceeds maximum "
                    f"allowed increase of {config.max_budget_increase_pct}%."
                ),
            )
        if change_pct >= config.require_double_confirm_above_pct:
            return ValidationResult(
                is_valid=True,
                needs_double_confirm=True,
                message=f"Budget increase of {change_pct:.0f}% requires double confirmation.",
            )
    else:
        decrease_pct = abs(change_pct)
        if decrease_pct > config.max_budget_decrease_pct:
            return ValidationResult(
                is_valid=False,
                message=(
                    f"Budget decrease of {decrease_pct:.0f}% exceeds maximum "
                    f"allowed decrease of {config.max_budget_decrease_pct}%."
                ),
            )

    return ValidationResult(is_valid=True)


def validate_bid_change(
    current_micros: int,
    proposed_micros: int,
    config: SafetyConfig,
) -> ValidationResult:
    """Validate a bid change against configured caps."""
    if current_micros == 0:
        return ValidationResult(is_valid=True)

    if proposed_micros == current_micros:
        return ValidationResult(is_valid=True)

    change_pct = ((proposed_micros - current_micros) / current_micros) * 100

    if change_pct > 0 and change_pct > config.max_bid_increase_pct:
        return ValidationResult(
            is_valid=False,
            message=(
                f"Bid increase of {change_pct:.0f}% exceeds maximum "
                f"allowed increase of {config.max_bid_increase_pct}%."
            ),
        )
    if change_pct < 0 and abs(change_pct) > config.max_bid_decrease_pct:
        return ValidationResult(
            is_valid=False,
            message=(
                f"Bid decrease of {abs(change_pct):.0f}% exceeds maximum "
                f"allowed decrease of {config.max_bid_decrease_pct}%."
            ),
        )

    return ValidationResult(is_valid=True)


def validate_not_blocked(operation: str, config: SafetyConfig) -> ValidationResult:
    """Check if an operation type is blocked."""
    if operation.upper() in [op.upper() for op in config.blocked_operations]:
        return ValidationResult(
            is_valid=False,
            message=f"Operation '{operation}' is blocked in config.yaml.",
        )
    return ValidationResult(is_valid=True)


def validate_state_not_stale(
    expected_value: str,
    actual_value: str,
) -> ValidationResult:
    """Check if entity state has changed since the plan was created."""
    if str(expected_value) != str(actual_value):
        return ValidationResult(
            is_valid=False,
            message=(
                f"Entity state has changed since the plan was created. "
                f"Expected '{expected_value}' but found '{actual_value}'. "
                f"Create a new plan to proceed."
            ),
        )
    return ValidationResult(is_valid=True)
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `pytest tests/test_validators.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/safety/validators.py tests/test_validators.py
git commit -m "feat: add safety validators for budget/bid caps and stale state"
```

---

## Task 8: Write Lock (Session Passphrase)

**Files:**
- Create: `google_ads_mcp/tools/write_lock.py`
- Test: `tests/test_write_lock.py`

- [ ] **Step 1: Write failing tests**

```python
# tests/test_write_lock.py
from google_ads_mcp.tools.write_lock import (
    is_unlocked,
    try_unlock,
    lock,
    reset_lock,
)


def test_starts_locked():
    reset_lock()
    assert not is_unlocked()


def test_unlock_with_correct_passphrase():
    reset_lock()
    result = try_unlock("correct-pass", expected="correct-pass")
    assert result is True
    assert is_unlocked()


def test_unlock_with_wrong_passphrase():
    reset_lock()
    result = try_unlock("wrong-pass", expected="correct-pass")
    assert result is False
    assert not is_unlocked()


def test_lock_after_unlock():
    reset_lock()
    try_unlock("pass", expected="pass")
    assert is_unlocked()
    lock()
    assert not is_unlocked()


def test_unlock_disabled_when_no_passphrase():
    reset_lock()
    result = try_unlock("anything", expected="")
    assert result is True
    assert is_unlocked()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_write_lock.py -v`
Expected: FAIL

- [ ] **Step 3: Implement write_lock.py**

```python
# google_ads_mcp/tools/write_lock.py
"""Session-level write lock with passphrase.

All write tools check is_unlocked() before creating ChangePlans.
The passphrase is configured in config.yaml under safety.write_passphrase.
If no passphrase is set (empty string), writes are unlocked by default.

Lock state resets when the MCP server restarts.
"""

_session_unlocked: bool = False


def is_unlocked() -> bool:
    """Check if writes are unlocked for this session."""
    return _session_unlocked


def try_unlock(passphrase: str, expected: str) -> bool:
    """Attempt to unlock writes with a passphrase.

    Args:
        passphrase: The passphrase provided by the user.
        expected: The passphrase from config.yaml.

    Returns:
        True if unlocked successfully, False if wrong passphrase.
    """
    global _session_unlocked
    if expected == "" or passphrase == expected:
        _session_unlocked = True
        return True
    return False


def lock():
    """Re-lock writes for this session."""
    global _session_unlocked
    _session_unlocked = False


def reset_lock():
    """Reset to locked state (for testing)."""
    global _session_unlocked
    _session_unlocked = False
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `pytest tests/test_write_lock.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/tools/write_lock.py tests/test_write_lock.py
git commit -m "feat: add session passphrase write lock"
```

---

## Task 9: GAQL and Formatting Utilities

**Files:**
- Create: `google_ads_mcp/utils/gaql.py`
- Create: `google_ads_mcp/utils/formatting.py`

- [ ] **Step 1: Implement gaql.py**

```python
# google_ads_mcp/utils/gaql.py
"""GAQL query validation and helpers."""

VALID_DATE_RANGES = {
    "LAST_7_DAYS",
    "LAST_30_DAYS",
    "LAST_90_DAYS",
    "THIS_MONTH",
    "LAST_MONTH",
    "TODAY",
    "YESTERDAY",
}

MUTATE_KEYWORDS = {"INSERT", "UPDATE", "DELETE", "MUTATE", "CREATE", "REMOVE"}


def validate_date_range(date_range: str) -> str | None:
    """Return error message if date_range is invalid, None if valid."""
    if date_range.upper() not in VALID_DATE_RANGES:
        return f"Invalid date_range '{date_range}'. Valid: {', '.join(sorted(VALID_DATE_RANGES))}"
    return None


def is_read_only_query(query: str) -> bool:
    """Check that a GAQL query contains no mutate keywords."""
    tokens = query.upper().split()
    return not any(token in MUTATE_KEYWORDS for token in tokens)
```

- [ ] **Step 2: Implement formatting.py**

```python
# google_ads_mcp/utils/formatting.py
"""Format Google Ads API responses for human-readable output."""

import json
from google_ads_mcp.utils.micros import micros_to_currency


def format_campaign_row(row) -> dict:
    """Format a single campaign row from GAQL response."""
    budget_micros = 0
    budget_delivery = "UNKNOWN"
    try:
        budget_micros = row.campaign_budget.amount_micros
        budget_delivery = row.campaign_budget.delivery_method.name
    except AttributeError:
        pass

    return {
        "id": str(row.campaign.id),
        "name": row.campaign.name,
        "status": row.campaign.status.name,
        "budget": f"{micros_to_currency(budget_micros):.2f}/day",
        "budget_micros": budget_micros,
        "budget_delivery": budget_delivery,
        "bidding_strategy": row.campaign.bidding_strategy_type.name,
        "channel_type": row.campaign.advertising_channel_type.name,
        "start_date": row.campaign.start_date,
        "end_date": row.campaign.end_date,
    }


def format_ad_group_row(row) -> dict:
    """Format a single ad group row."""
    return {
        "id": str(row.ad_group.id),
        "name": row.ad_group.name,
        "status": row.ad_group.status.name,
        "cpc_bid": f"{micros_to_currency(row.ad_group.cpc_bid_micros):.2f}",
        "cpc_bid_micros": row.ad_group.cpc_bid_micros,
        "campaign": row.ad_group.campaign,
    }


def format_keyword_row(row) -> dict:
    """Format a single keyword criterion row."""
    qs = None
    try:
        qs = row.ad_group_criterion.quality_info.quality_score
    except AttributeError:
        pass

    return {
        "id": str(row.ad_group_criterion.criterion_id),
        "text": row.ad_group_criterion.keyword.text,
        "match_type": row.ad_group_criterion.keyword.match_type.name,
        "status": row.ad_group_criterion.status.name,
        "cpc_bid": f"{micros_to_currency(row.ad_group_criterion.effective_cpc_bid_micros):.2f}",
        "cpc_bid_micros": row.ad_group_criterion.effective_cpc_bid_micros,
        "quality_score": qs,
        "approval_status": row.ad_group_criterion.approval_status.name,
    }


def format_ad_row(row) -> dict:
    """Format a single ad row."""
    headlines = []
    descriptions = []
    try:
        headlines = [h.text for h in row.ad_group_ad.ad.responsive_search_ad.headlines]
        descriptions = [d.text for d in row.ad_group_ad.ad.responsive_search_ad.descriptions]
    except AttributeError:
        pass

    final_urls = list(row.ad_group_ad.ad.final_urls) if row.ad_group_ad.ad.final_urls else []

    return {
        "id": str(row.ad_group_ad.ad.id),
        "type": row.ad_group_ad.ad.type_.name,
        "status": row.ad_group_ad.status.name,
        "headlines": headlines,
        "descriptions": descriptions,
        "final_urls": final_urls,
        "approval_status": row.ad_group_ad.policy_summary.approval_status.name,
    }


def format_metrics(row, source: str = "campaign") -> dict:
    """Format metrics from a GAQL response row."""
    cost = micros_to_currency(row.metrics.cost_micros)
    conv_value = row.metrics.conversions_value
    roas = (conv_value / cost) if cost > 0 else 0.0

    return {
        "impressions": row.metrics.impressions,
        "clicks": row.metrics.clicks,
        "cost": f"{cost:.2f}",
        "cost_micros": row.metrics.cost_micros,
        "conversions": round(row.metrics.conversions, 2),
        "conversion_value": round(conv_value, 2),
        "ctr": f"{row.metrics.ctr:.2%}",
        "average_cpc": f"{micros_to_currency(row.metrics.average_cpc):.2f}",
        "roas": f"{roas:.2f}",
    }


def format_results(results: list[dict]) -> str:
    """Format a list of result dicts as readable JSON string."""
    return json.dumps(results, indent=2, default=str)
```

- [ ] **Step 3: Commit**

```bash
git add google_ads_mcp/utils/gaql.py google_ads_mcp/utils/formatting.py
git commit -m "feat: add GAQL validation and response formatting utilities"
```

---

## Task 10: Server Entrypoint

**Files:**
- Create: `google_ads_mcp/server.py`

- [ ] **Step 1: Implement server.py**

```python
# google_ads_mcp/server.py
"""Google Ads MCP server entrypoint.

Registers all tools and runs on stdio transport.

NOTE on async: The MCP Python SDK (FastMCP) requires async tool handlers.
All Google Ads API calls inside handlers are synchronous — the 'async def'
is a cosmetic requirement of the SDK, not an architectural choice.
"""

from mcp.server.fastmcp import FastMCP
from dotenv import load_dotenv

load_dotenv()

mcp = FastMCP("google-ads", version="0.1.0")


def register_tools():
    """Import tool modules to trigger @mcp.tool() registration."""
    from google_ads_mcp.tools import read  # noqa: F401
    from google_ads_mcp.tools import write  # noqa: F401
    from google_ads_mcp.tools import confirm  # noqa: F401
    from google_ads_mcp.tools import write_lock_tools  # noqa: F401


register_tools()


if __name__ == "__main__":
    mcp.run()
```

- [ ] **Step 2: Commit**

```bash
git add google_ads_mcp/server.py
git commit -m "feat: add MCP server entrypoint with tool registration"
```

---

## Task 11: Read Tools — Accounts and Campaigns

**Files:**
- Create: `google_ads_mcp/tools/read.py`
- Test: `tests/test_read_tools.py`

- [ ] **Step 1: Write failing tests for read tools**

```python
# tests/test_read_tools.py
import json
import pytest
from unittest.mock import MagicMock, patch


def _mock_row(**kwargs):
    """Build a mock GAQL response row."""
    row = MagicMock()
    for path, value in kwargs.items():
        parts = path.split(".")
        obj = row
        for part in parts[:-1]:
            obj = getattr(obj, part)
        setattr(obj, parts[-1], value)
    return row


@patch("google_ads_mcp.tools.read.get_client")
@patch("google_ads_mcp.tools.read.get_config")
@pytest.mark.asyncio
async def test_list_campaigns(mock_config, mock_get_client):
    from google_ads_mcp.tools.read import list_campaigns

    mock_client = MagicMock()
    mock_get_client.return_value = mock_client

    mock_service = MagicMock()
    mock_client.get_service.return_value = mock_service

    # Build mock row
    row = MagicMock()
    row.campaign.id = 123
    row.campaign.name = "Brand - NL"
    row.campaign.status.name = "ENABLED"
    row.campaign_budget.amount_micros = 50_000_000
    row.campaign_budget.delivery_method.name = "STANDARD"
    row.campaign.bidding_strategy_type.name = "TARGET_CPA"
    row.campaign.advertising_channel_type.name = "SEARCH"
    row.campaign.start_date = "2026-01-01"
    row.campaign.end_date = ""

    mock_service.search.return_value = [row]

    result = await list_campaigns(customer_id="1234567890")
    parsed = json.loads(result)
    assert len(parsed) == 1
    assert parsed[0]["name"] == "Brand - NL"
    assert parsed[0]["status"] == "ENABLED"
    assert parsed[0]["budget"] == "50.00/day"


@patch("google_ads_mcp.tools.read.get_client")
@patch("google_ads_mcp.tools.read.get_config")
@pytest.mark.asyncio
async def test_run_gaql_rejects_mutate(mock_config, mock_get_client):
    from google_ads_mcp.tools.read import run_gaql

    result = await run_gaql(customer_id="123", query="DELETE FROM campaign WHERE id = 1")
    assert "rejected" in result.lower() or "read-only" in result.lower()


@patch("google_ads_mcp.tools.read.get_client")
@patch("google_ads_mcp.tools.read.get_config")
@pytest.mark.asyncio
async def test_list_accounts(mock_config, mock_get_client):
    from google_ads_mcp.tools.read import list_accounts

    mock_client = MagicMock()
    mock_get_client.return_value = mock_client

    mock_service = MagicMock()
    mock_client.get_service.return_value = mock_service

    row = MagicMock()
    row.customer_client.id = 111
    row.customer_client.descriptive_name = "Test Account"
    row.customer_client.currency_code = "EUR"
    row.customer_client.time_zone = "Europe/Amsterdam"
    row.customer_client.status.name = "ENABLED"

    mock_service.search.return_value = [row]

    result = await list_accounts()
    parsed = json.loads(result)
    assert len(parsed) == 1
    assert parsed[0]["name"] == "Test Account"
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_read_tools.py -v`
Expected: FAIL

- [ ] **Step 3: Implement read.py with all 9 read tools**

```python
# google_ads_mcp/tools/read.py
"""Read-only MCP tools for Google Ads data retrieval."""

import json
import time
from google.ads.googleads.errors import GoogleAdsException

from google_ads_mcp.server import mcp
from google_ads_mcp.auth import get_client
from google_ads_mcp.config import get_config
from google_ads_mcp.safety.audit_log import AuditLogger
from google_ads_mcp.utils.gaql import validate_date_range, is_read_only_query
from google_ads_mcp.utils.micros import micros_to_currency
from google_ads_mcp.utils.formatting import (
    format_campaign_row,
    format_ad_group_row,
    format_keyword_row,
    format_ad_row,
    format_metrics,
    format_results,
)


def _error_response(e: GoogleAdsException) -> str:
    """Format GoogleAdsException as a readable error."""
    errors = []
    for error in e.failure.errors:
        errors.append({
            "error_code": str(error.error_code),
            "message": error.message,
        })
    return json.dumps({
        "error": True,
        "request_id": e.request_id,
        "failure_details": errors,
    }, indent=2)


def _get_audit_logger() -> AuditLogger:
    config = get_config()
    return AuditLogger(config.safety.audit_log_path)


@mcp.tool()
async def list_accounts() -> str:
    """List all accessible customer accounts under the MCC.

    Returns accounts with: customer_id, name, currency, timezone, status.
    This queries the MCC (manager account) configured in your credentials.
    """
    client = get_client()
    config = get_config()
    ga_service = client.get_service("GoogleAdsService")
    login_customer_id = client.login_customer_id

    query = """
        SELECT
            customer_client.id,
            customer_client.descriptive_name,
            customer_client.currency_code,
            customer_client.time_zone,
            customer_client.status
        FROM customer_client
        WHERE customer_client.manager = FALSE
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=login_customer_id, query=query)
        results = []
        for row in response:
            results.append({
                "customer_id": str(row.customer_client.id),
                "name": row.customer_client.descriptive_name,
                "currency": row.customer_client.currency_code,
                "timezone": row.customer_client.time_zone,
                "status": row.customer_client.status.name,
            })
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("list_accounts", login_customer_id, query.strip(), len(results), duration)
        return format_results(results)
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def list_campaigns(customer_id: str) -> str:
    """List all campaigns for a Google Ads account.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
    """
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    query = """
        SELECT
            campaign.id,
            campaign.name,
            campaign.status,
            campaign_budget.amount_micros,
            campaign_budget.delivery_method,
            campaign.bidding_strategy_type,
            campaign.advertising_channel_type,
            campaign.start_date,
            campaign.end_date
        FROM campaign
        ORDER BY campaign.name
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = [format_campaign_row(row) for row in response]
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("list_campaigns", customer_id, query.strip(), len(results), duration)
        return format_results(results)
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def get_campaign(customer_id: str, campaign_id: str) -> str:
    """Get full detail for a single campaign.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        campaign_id: The campaign ID.

    Returns all fields including serving_status, optimization_score, labels.
    """
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    query = f"""
        SELECT
            campaign.id,
            campaign.name,
            campaign.status,
            campaign_budget.amount_micros,
            campaign_budget.delivery_method,
            campaign.bidding_strategy_type,
            campaign.advertising_channel_type,
            campaign.start_date,
            campaign.end_date,
            campaign.serving_status,
            campaign.optimization_score,
            campaign.labels
        FROM campaign
        WHERE campaign.id = {campaign_id}
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = []
        for row in response:
            data = format_campaign_row(row)
            data["serving_status"] = row.campaign.serving_status.name
            data["optimization_score"] = row.campaign.optimization_score
            data["labels"] = list(row.campaign.labels)
            results.append(data)
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("get_campaign", customer_id, query.strip(), len(results), duration)
        if not results:
            return json.dumps({"error": True, "message": f"Campaign {campaign_id} not found."})
        return format_results(results[0])
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def list_ad_groups(customer_id: str, campaign_id: str) -> str:
    """List all ad groups for a campaign.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        campaign_id: The campaign ID.
    """
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    query = f"""
        SELECT
            ad_group.id,
            ad_group.name,
            ad_group.status,
            ad_group.cpc_bid_micros,
            ad_group.campaign
        FROM ad_group
        WHERE campaign.id = {campaign_id}
        ORDER BY ad_group.name
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = [format_ad_group_row(row) for row in response]
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("list_ad_groups", customer_id, query.strip(), len(results), duration)
        return format_results(results)
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def get_campaign_metrics(customer_id: str, campaign_id: str, date_range: str = "LAST_30_DAYS") -> str:
    """Get performance metrics for a campaign.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        campaign_id: The campaign ID.
        date_range: One of LAST_7_DAYS, LAST_30_DAYS, LAST_90_DAYS, THIS_MONTH, LAST_MONTH.

    Returns: impressions, clicks, cost, conversions, conversion_value, ctr, average_cpc, roas.
    """
    error = validate_date_range(date_range)
    if error:
        return json.dumps({"error": True, "message": error})

    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    query = f"""
        SELECT
            campaign.id,
            campaign.name,
            metrics.impressions,
            metrics.clicks,
            metrics.cost_micros,
            metrics.conversions,
            metrics.conversions_value,
            metrics.ctr,
            metrics.average_cpc
        FROM campaign
        WHERE campaign.id = {campaign_id}
            AND segments.date DURING {date_range.upper()}
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = []
        for row in response:
            data = format_metrics(row)
            data["campaign_id"] = str(row.campaign.id)
            data["campaign_name"] = row.campaign.name
            data["date_range"] = date_range.upper()
            results.append(data)
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("get_campaign_metrics", customer_id, query.strip(), len(results), duration)
        return format_results(results[0] if results else {"message": "No data for this period."})
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def get_account_metrics(customer_id: str, date_range: str = "LAST_30_DAYS") -> str:
    """Get account-level performance metrics.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        date_range: One of LAST_7_DAYS, LAST_30_DAYS, LAST_90_DAYS, THIS_MONTH, LAST_MONTH.

    Returns: impressions, clicks, cost, conversions, conversion_value, ctr, average_cpc, roas.
    """
    error = validate_date_range(date_range)
    if error:
        return json.dumps({"error": True, "message": error})

    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    query = f"""
        SELECT
            metrics.impressions,
            metrics.clicks,
            metrics.cost_micros,
            metrics.conversions,
            metrics.conversions_value,
            metrics.ctr,
            metrics.average_cpc
        FROM customer
        WHERE segments.date DURING {date_range.upper()}
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = []
        for row in response:
            data = format_metrics(row)
            data["customer_id"] = customer_id
            data["date_range"] = date_range.upper()
            results.append(data)
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("get_account_metrics", customer_id, query.strip(), len(results), duration)
        return format_results(results[0] if results else {"message": "No data for this period."})
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def list_keywords(customer_id: str, ad_group_id: str) -> str:
    """List all keywords in an ad group.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID.

    Returns: id, text, match_type, status, cpc_bid, quality_score, approval_status.
    """
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    query = f"""
        SELECT
            ad_group_criterion.criterion_id,
            ad_group_criterion.keyword.text,
            ad_group_criterion.keyword.match_type,
            ad_group_criterion.status,
            ad_group_criterion.effective_cpc_bid_micros,
            ad_group_criterion.quality_info.quality_score,
            ad_group_criterion.approval_status
        FROM ad_group_criterion
        WHERE ad_group.id = {ad_group_id}
            AND ad_group_criterion.type = KEYWORD
        ORDER BY ad_group_criterion.keyword.text
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = [format_keyword_row(row) for row in response]
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("list_keywords", customer_id, query.strip(), len(results), duration)
        return format_results(results)
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def list_ads(customer_id: str, ad_group_id: str) -> str:
    """List all ads in an ad group.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID.

    Returns: id, type, status, headlines, descriptions, final_urls, approval_status.
    """
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    query = f"""
        SELECT
            ad_group_ad.ad.id,
            ad_group_ad.ad.type,
            ad_group_ad.status,
            ad_group_ad.ad.responsive_search_ad.headlines,
            ad_group_ad.ad.responsive_search_ad.descriptions,
            ad_group_ad.ad.final_urls,
            ad_group_ad.policy_summary.approval_status
        FROM ad_group_ad
        WHERE ad_group.id = {ad_group_id}
        ORDER BY ad_group_ad.ad.id
    """

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = [format_ad_row(row) for row in response]
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("list_ads", customer_id, query.strip(), len(results), duration)
        return format_results(results)
    except GoogleAdsException as e:
        return _error_response(e)


@mcp.tool()
async def run_gaql(customer_id: str, query: str) -> str:
    """Execute an arbitrary GAQL query (read-only).

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        query: A valid GAQL SELECT query. INSERT/UPDATE/DELETE/MUTATE queries are rejected.

    Returns results as a list of dicts.
    """
    if not is_read_only_query(query):
        return json.dumps({
            "error": True,
            "message": "Query rejected: run_gaql only accepts read-only SELECT queries. "
                       "Mutate keywords (INSERT, UPDATE, DELETE, MUTATE, CREATE, REMOVE) are not allowed.",
        })

    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    start = time.time()
    try:
        response = ga_service.search(customer_id=customer_id, query=query)
        results = []
        for row in response:
            row_dict = {}
            # Convert protobuf row to dict using the message's fields
            for field in row._pb.DESCRIPTOR.fields:
                if row._pb.HasField(field.name):
                    value = getattr(row, field.name)
                    row_dict[field.name] = str(value)
            results.append(row_dict)
        duration = int((time.time() - start) * 1000)
        _get_audit_logger().log_read("run_gaql", customer_id, query.strip(), len(results), duration)
        return format_results(results)
    except GoogleAdsException as e:
        return _error_response(e)
```

- [ ] **Step 4: Run tests**

Run: `pytest tests/test_read_tools.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/tools/read.py tests/test_read_tools.py
git commit -m "feat: add 9 read-only MCP tools for Google Ads data"
```

---

## Task 12: Write Tools — All Status Changes and Budget/Bid Updates

**Files:**
- Create: `google_ads_mcp/tools/write.py`
- Test: `tests/test_write_tools.py`

- [ ] **Step 1: Write failing tests for write tools**

```python
# tests/test_write_tools.py
import json
import pytest
from unittest.mock import MagicMock, patch
from google_ads_mcp.tools.write_lock import reset_lock, try_unlock


@pytest.fixture(autouse=True)
def unlock_writes():
    """Unlock writes for all tests in this module."""
    reset_lock()
    try_unlock("test", expected="test")
    yield
    reset_lock()


@patch("google_ads_mcp.tools.write._read_current_campaign")
@patch("google_ads_mcp.tools.write.get_config")
@pytest.mark.asyncio
async def test_pause_campaign_creates_plan(mock_config, mock_read):
    from google_ads_mcp.tools.write import pause_campaign
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test"),
        defaults=DefaultsConfig(),
    )
    mock_read.return_value = {
        "name": "Brand - NL",
        "status": "ENABLED",
        "resource_name": "customers/123/campaigns/456",
    }

    result = await pause_campaign(customer_id="123", campaign_id="456")
    assert "PROPOSED" in result or "Plan ID" in result
    assert "Brand - NL" in result
    assert "PAUSED" in result


@patch("google_ads_mcp.tools.write._read_current_campaign")
@patch("google_ads_mcp.tools.write.get_config")
@pytest.mark.asyncio
async def test_pause_campaign_locked(mock_config, mock_read):
    from google_ads_mcp.tools.write import pause_campaign
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    reset_lock()  # Ensure locked

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test"),
        defaults=DefaultsConfig(),
    )

    result = await pause_campaign(customer_id="123", campaign_id="456")
    assert "locked" in result.lower()


@patch("google_ads_mcp.tools.write._read_current_campaign_budget")
@patch("google_ads_mcp.tools.write.get_config")
@pytest.mark.asyncio
async def test_update_budget_validates_micros_guard(mock_config, mock_read):
    from google_ads_mcp.tools.write import update_campaign_budget
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test"),
        defaults=DefaultsConfig(),
    )

    result = await update_campaign_budget(
        customer_id="123",
        campaign_id="456",
        new_daily_budget=50_000_000,  # Looks like raw micros!
    )
    assert "micros" in result.lower() or "rejected" in result.lower()


@patch("google_ads_mcp.tools.write._read_current_campaign_budget")
@patch("google_ads_mcp.tools.write.get_config")
@pytest.mark.asyncio
async def test_update_budget_validates_cap(mock_config, mock_read):
    from google_ads_mcp.tools.write import update_campaign_budget
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test", max_budget_increase_pct=50),
        defaults=DefaultsConfig(),
    )
    mock_read.return_value = {
        "budget_micros": 50_000_000,
        "budget_resource_name": "customers/123/campaignBudgets/789",
        "campaign_name": "Brand - NL",
    }

    result = await update_campaign_budget(
        customer_id="123",
        campaign_id="456",
        new_daily_budget=90.0,  # 80% increase, exceeds 50% cap
    )
    assert "exceeds" in result.lower()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_write_tools.py -v`
Expected: FAIL

- [ ] **Step 3: Implement write.py with all 11 write tools**

```python
# google_ads_mcp/tools/write.py
"""Write MCP tools for Google Ads mutations.

IMPORTANT: These tools NEVER execute mutations directly. They create
ChangePlans and return descriptions. The confirm_change tool executes
the actual mutation after user approval.

Safety gates:
1. Session write lock (passphrase required)
2. Micros guard (rejects raw micros, accepts human currency)
3. Budget/bid caps (configurable in config.yaml)
4. Draft-then-confirm (plan must be confirmed separately)
"""

import json
from google.ads.googleads.errors import GoogleAdsException

from google_ads_mcp.server import mcp
from google_ads_mcp.auth import get_client
from google_ads_mcp.config import get_config
from google_ads_mcp.models.change_plan import create_plan
from google_ads_mcp.safety.plan_store import PlanStore
from google_ads_mcp.safety.validators import (
    validate_budget_change,
    validate_bid_change,
    validate_not_blocked,
)
from google_ads_mcp.tools.write_lock import is_unlocked
from google_ads_mcp.utils.micros import (
    currency_to_micros,
    micros_to_currency,
    validate_not_raw_micros,
)


_plan_store = PlanStore()


def get_plan_store() -> PlanStore:
    """Get the global plan store (also used by confirm.py)."""
    return _plan_store


def _check_write_lock() -> str | None:
    """Return error message if writes are locked, None if unlocked."""
    if not is_unlocked():
        return (
            "Writes are locked for this session. "
            "Call unlock_writes(passphrase) with the passphrase from config.yaml first."
        )
    return None


# --- Helpers to read current state from API ---

def _read_current_campaign(customer_id: str, campaign_id: str) -> dict:
    """Read current campaign state from the API."""
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")
    query = f"""
        SELECT
            campaign.id,
            campaign.name,
            campaign.status,
            campaign.resource_name
        FROM campaign
        WHERE campaign.id = {campaign_id}
    """
    response = ga_service.search(customer_id=customer_id, query=query)
    for row in response:
        return {
            "name": row.campaign.name,
            "status": row.campaign.status.name,
            "resource_name": row.campaign.resource_name,
        }
    raise ValueError(f"Campaign {campaign_id} not found in account {customer_id}.")


def _read_current_campaign_budget(customer_id: str, campaign_id: str) -> dict:
    """Read current campaign budget from the API."""
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")
    query = f"""
        SELECT
            campaign.name,
            campaign_budget.amount_micros,
            campaign_budget.resource_name
        FROM campaign
        WHERE campaign.id = {campaign_id}
    """
    response = ga_service.search(customer_id=customer_id, query=query)
    for row in response:
        return {
            "campaign_name": row.campaign.name,
            "budget_micros": row.campaign_budget.amount_micros,
            "budget_resource_name": row.campaign_budget.resource_name,
        }
    raise ValueError(f"Campaign {campaign_id} not found in account {customer_id}.")


def _read_current_ad_group(customer_id: str, ad_group_id: str) -> dict:
    """Read current ad group state from the API."""
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")
    query = f"""
        SELECT
            ad_group.id,
            ad_group.name,
            ad_group.status,
            ad_group.cpc_bid_micros,
            ad_group.resource_name
        FROM ad_group
        WHERE ad_group.id = {ad_group_id}
    """
    response = ga_service.search(customer_id=customer_id, query=query)
    for row in response:
        return {
            "name": row.ad_group.name,
            "status": row.ad_group.status.name,
            "cpc_bid_micros": row.ad_group.cpc_bid_micros,
            "resource_name": row.ad_group.resource_name,
        }
    raise ValueError(f"Ad group {ad_group_id} not found in account {customer_id}.")


def _read_current_keyword(customer_id: str, ad_group_id: str, criterion_id: str) -> dict:
    """Read current keyword criterion state from the API."""
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")
    query = f"""
        SELECT
            ad_group_criterion.criterion_id,
            ad_group_criterion.keyword.text,
            ad_group_criterion.status,
            ad_group_criterion.effective_cpc_bid_micros,
            ad_group_criterion.resource_name
        FROM ad_group_criterion
        WHERE ad_group.id = {ad_group_id}
            AND ad_group_criterion.criterion_id = {criterion_id}
            AND ad_group_criterion.type = KEYWORD
    """
    response = ga_service.search(customer_id=customer_id, query=query)
    for row in response:
        return {
            "text": row.ad_group_criterion.keyword.text,
            "status": row.ad_group_criterion.status.name,
            "cpc_bid_micros": row.ad_group_criterion.effective_cpc_bid_micros,
            "resource_name": row.ad_group_criterion.resource_name,
        }
    raise ValueError(f"Keyword {criterion_id} not found in ad group {ad_group_id}.")


def _read_current_ad(customer_id: str, ad_group_id: str, ad_id: str) -> dict:
    """Read current ad state from the API."""
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")
    query = f"""
        SELECT
            ad_group_ad.ad.id,
            ad_group_ad.ad.name,
            ad_group_ad.status,
            ad_group_ad.resource_name
        FROM ad_group_ad
        WHERE ad_group.id = {ad_group_id}
            AND ad_group_ad.ad.id = {ad_id}
    """
    response = ga_service.search(customer_id=customer_id, query=query)
    for row in response:
        return {
            "name": getattr(row.ad_group_ad.ad, "name", f"Ad {ad_id}"),
            "status": row.ad_group_ad.status.name,
            "resource_name": row.ad_group_ad.resource_name,
        }
    raise ValueError(f"Ad {ad_id} not found in ad group {ad_group_id}.")


# --- Campaign status tools ---

@mcp.tool()
async def pause_campaign(customer_id: str, campaign_id: str) -> str:
    """Propose pausing a campaign. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        campaign_id: The campaign ID to pause.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_campaign(customer_id, campaign_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "PAUSED":
        return f"Campaign '{current['name']}' is already PAUSED."

    plan = create_plan(
        tool_name="pause_campaign",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="campaign",
        entity_name=current["name"],
        field="status",
        old_value=current["status"],
        new_value="PAUSED",
        old_display=current["status"],
        new_display="PAUSED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


@mcp.tool()
async def enable_campaign(customer_id: str, campaign_id: str) -> str:
    """Propose enabling a campaign. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        campaign_id: The campaign ID to enable.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_campaign(customer_id, campaign_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "ENABLED":
        return f"Campaign '{current['name']}' is already ENABLED."

    plan = create_plan(
        tool_name="enable_campaign",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="campaign",
        entity_name=current["name"],
        field="status",
        old_value=current["status"],
        new_value="ENABLED",
        old_display=current["status"],
        new_display="ENABLED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


# --- Budget tool ---

@mcp.tool()
async def update_campaign_budget(customer_id: str, campaign_id: str, new_daily_budget: float) -> str:
    """Propose updating a campaign's daily budget. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        campaign_id: The campaign ID.
        new_daily_budget: New daily budget in currency units (e.g., 75.00 for 75 EUR).
                          NOT in micros. Values above 10,000 are rejected as likely micros.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    # Micros guard
    micros_error = validate_not_raw_micros(new_daily_budget)
    if micros_error:
        return json.dumps({"error": True, "message": micros_error})

    if new_daily_budget < 0:
        return json.dumps({"error": True, "message": "Budget cannot be negative."})

    config = get_config()
    try:
        current = _read_current_campaign_budget(customer_id, campaign_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    new_micros = currency_to_micros(new_daily_budget)
    current_micros = current["budget_micros"]

    # Budget cap validation
    validation = validate_budget_change(current_micros, new_micros, config.safety)
    if not validation.is_valid:
        return json.dumps({"error": True, "message": validation.message})

    current_display = f"{micros_to_currency(current_micros):.2f}/day"
    new_display = f"{new_daily_budget:.2f}/day"

    plan = create_plan(
        tool_name="update_campaign_budget",
        customer_id=customer_id,
        resource_name=current["budget_resource_name"],
        entity_type="campaign",
        entity_name=current["campaign_name"],
        field="budget",
        old_value=current_micros,
        new_value=new_micros,
        old_display=current_display,
        new_display=new_display,
        ttl_seconds=config.safety.plan_ttl_seconds,
        needs_double_confirm=validation.needs_double_confirm,
        double_confirm_reason=validation.message if validation.needs_double_confirm else None,
    )
    _plan_store.add(plan)
    return plan.format_description()


# --- Ad group status tools ---

@mcp.tool()
async def pause_ad_group(customer_id: str, ad_group_id: str) -> str:
    """Propose pausing an ad group. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID to pause.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_ad_group(customer_id, ad_group_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "PAUSED":
        return f"Ad group '{current['name']}' is already PAUSED."

    plan = create_plan(
        tool_name="pause_ad_group",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="ad_group",
        entity_name=current["name"],
        field="status",
        old_value=current["status"],
        new_value="PAUSED",
        old_display=current["status"],
        new_display="PAUSED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


@mcp.tool()
async def enable_ad_group(customer_id: str, ad_group_id: str) -> str:
    """Propose enabling an ad group. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID to enable.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_ad_group(customer_id, ad_group_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "ENABLED":
        return f"Ad group '{current['name']}' is already ENABLED."

    plan = create_plan(
        tool_name="enable_ad_group",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="ad_group",
        entity_name=current["name"],
        field="status",
        old_value=current["status"],
        new_value="ENABLED",
        old_display=current["status"],
        new_display="ENABLED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


# --- Ad group bid tool ---

@mcp.tool()
async def update_ad_group_bid(customer_id: str, ad_group_id: str, new_cpc_bid: float) -> str:
    """Propose updating the default CPC bid for an ad group.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID.
        new_cpc_bid: New CPC bid in currency units (e.g., 1.50 for 1.50 EUR).
                     NOT in micros.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    micros_error = validate_not_raw_micros(new_cpc_bid)
    if micros_error:
        return json.dumps({"error": True, "message": micros_error})

    if new_cpc_bid < 0:
        return json.dumps({"error": True, "message": "Bid cannot be negative."})

    config = get_config()
    try:
        current = _read_current_ad_group(customer_id, ad_group_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    new_micros = currency_to_micros(new_cpc_bid)
    current_micros = current["cpc_bid_micros"]

    validation = validate_bid_change(current_micros, new_micros, config.safety)
    if not validation.is_valid:
        return json.dumps({"error": True, "message": validation.message})

    plan = create_plan(
        tool_name="update_ad_group_bid",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="ad_group",
        entity_name=current["name"],
        field="cpc_bid",
        old_value=current_micros,
        new_value=new_micros,
        old_display=f"{micros_to_currency(current_micros):.2f}",
        new_display=f"{new_cpc_bid:.2f}",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


# --- Keyword status tools ---

@mcp.tool()
async def pause_keyword(customer_id: str, ad_group_id: str, criterion_id: str) -> str:
    """Propose pausing a keyword. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID containing the keyword.
        criterion_id: The keyword criterion ID.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_keyword(customer_id, ad_group_id, criterion_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "PAUSED":
        return f"Keyword '{current['text']}' is already PAUSED."

    plan = create_plan(
        tool_name="pause_keyword",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="keyword",
        entity_name=current["text"],
        field="status",
        old_value=current["status"],
        new_value="PAUSED",
        old_display=current["status"],
        new_display="PAUSED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


@mcp.tool()
async def enable_keyword(customer_id: str, ad_group_id: str, criterion_id: str) -> str:
    """Propose enabling a keyword. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID containing the keyword.
        criterion_id: The keyword criterion ID.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_keyword(customer_id, ad_group_id, criterion_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "ENABLED":
        return f"Keyword '{current['text']}' is already ENABLED."

    plan = create_plan(
        tool_name="enable_keyword",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="keyword",
        entity_name=current["text"],
        field="status",
        old_value=current["status"],
        new_value="ENABLED",
        old_display=current["status"],
        new_display="ENABLED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


# --- Keyword bid tool ---

@mcp.tool()
async def update_keyword_bid(customer_id: str, ad_group_id: str, criterion_id: str, new_cpc_bid: float) -> str:
    """Propose updating the CPC bid for a keyword.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID containing the keyword.
        criterion_id: The keyword criterion ID.
        new_cpc_bid: New CPC bid in currency units (e.g., 1.50 for 1.50 EUR). NOT in micros.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    micros_error = validate_not_raw_micros(new_cpc_bid)
    if micros_error:
        return json.dumps({"error": True, "message": micros_error})

    if new_cpc_bid < 0:
        return json.dumps({"error": True, "message": "Bid cannot be negative."})

    config = get_config()
    try:
        current = _read_current_keyword(customer_id, ad_group_id, criterion_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    new_micros = currency_to_micros(new_cpc_bid)
    current_micros = current["cpc_bid_micros"]

    validation = validate_bid_change(current_micros, new_micros, config.safety)
    if not validation.is_valid:
        return json.dumps({"error": True, "message": validation.message})

    plan = create_plan(
        tool_name="update_keyword_bid",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="keyword",
        entity_name=current["text"],
        field="cpc_bid",
        old_value=current_micros,
        new_value=new_micros,
        old_display=f"{micros_to_currency(current_micros):.2f}",
        new_display=f"{new_cpc_bid:.2f}",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


# --- Ad status tools ---

@mcp.tool()
async def pause_ad(customer_id: str, ad_group_id: str, ad_id: str) -> str:
    """Propose pausing an ad. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID containing the ad.
        ad_id: The ad ID to pause.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_ad(customer_id, ad_group_id, ad_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "PAUSED":
        return f"Ad '{current['name']}' is already PAUSED."

    plan = create_plan(
        tool_name="pause_ad",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="ad",
        entity_name=current["name"],
        field="status",
        old_value=current["status"],
        new_value="PAUSED",
        old_display=current["status"],
        new_display="PAUSED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()


@mcp.tool()
async def enable_ad(customer_id: str, ad_group_id: str, ad_id: str) -> str:
    """Propose enabling an ad. Creates a ChangePlan that must be confirmed.

    Args:
        customer_id: The Google Ads customer ID (10 digits, no dashes).
        ad_group_id: The ad group ID containing the ad.
        ad_id: The ad ID to enable.
    """
    lock_error = _check_write_lock()
    if lock_error:
        return lock_error

    config = get_config()
    try:
        current = _read_current_ad(customer_id, ad_group_id, ad_id)
    except (GoogleAdsException, ValueError) as e:
        return json.dumps({"error": True, "message": str(e)})

    if current["status"] == "ENABLED":
        return f"Ad '{current['name']}' is already ENABLED."

    plan = create_plan(
        tool_name="enable_ad",
        customer_id=customer_id,
        resource_name=current["resource_name"],
        entity_type="ad",
        entity_name=current["name"],
        field="status",
        old_value=current["status"],
        new_value="ENABLED",
        old_display=current["status"],
        new_display="ENABLED",
        ttl_seconds=config.safety.plan_ttl_seconds,
    )
    _plan_store.add(plan)
    return plan.format_description()
```

- [ ] **Step 4: Run tests**

Run: `pytest tests/test_write_tools.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/tools/write.py tests/test_write_tools.py
git commit -m "feat: add 11 write tools with safety gates and ChangePlan creation"
```

---

## Task 13: Confirm Tools

**Files:**
- Create: `google_ads_mcp/tools/confirm.py`
- Test: `tests/test_confirm.py`

- [ ] **Step 1: Write failing tests**

```python
# tests/test_confirm.py
import json
import pytest
from unittest.mock import MagicMock, patch
from google_ads_mcp.models.change_plan import create_plan
from google_ads_mcp.safety.plan_store import PlanStore
from google_ads_mcp.tools.write_lock import reset_lock, try_unlock


@pytest.fixture(autouse=True)
def unlock_writes():
    reset_lock()
    try_unlock("test", expected="test")
    yield
    reset_lock()


def _make_status_plan(store: PlanStore, tool: str = "pause_campaign") -> str:
    plan = create_plan(
        tool_name=tool,
        customer_id="123",
        resource_name="customers/123/campaigns/456",
        entity_type="campaign",
        entity_name="Brand - NL",
        field="status",
        old_value="ENABLED",
        new_value="PAUSED",
        old_display="ENABLED",
        new_display="PAUSED",
        ttl_seconds=300,
    )
    store.add(plan)
    return plan.plan_id


def _make_budget_plan(store: PlanStore, needs_double: bool = False) -> str:
    plan = create_plan(
        tool_name="update_campaign_budget",
        customer_id="123",
        resource_name="customers/123/campaignBudgets/789",
        entity_type="campaign",
        entity_name="Brand - NL",
        field="budget",
        old_value=50_000_000,
        new_value=75_000_000,
        old_display="50.00/day",
        new_display="75.00/day",
        ttl_seconds=300,
        needs_double_confirm=needs_double,
        double_confirm_reason="Budget increase exceeds 50%" if needs_double else None,
    )
    store.add(plan)
    return plan.plan_id


@patch("google_ads_mcp.tools.confirm._execute_mutation")
@patch("google_ads_mcp.tools.confirm._read_current_value")
@patch("google_ads_mcp.tools.confirm.get_plan_store")
@patch("google_ads_mcp.tools.confirm.get_config")
@pytest.mark.asyncio
async def test_confirm_executes_valid_plan(mock_config, mock_store_fn, mock_read, mock_execute):
    from google_ads_mcp.tools.confirm import confirm_change
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    store = PlanStore()
    plan_id = _make_status_plan(store)

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test"),
        defaults=DefaultsConfig(),
    )
    mock_store_fn.return_value = store
    mock_read.return_value = "ENABLED"  # Matches plan's old_value
    mock_execute.return_value = "success"

    result = await confirm_change(plan_id=plan_id)
    assert "success" in result.lower() or "applied" in result.lower()
    mock_execute.assert_called_once()


@patch("google_ads_mcp.tools.confirm.get_plan_store")
@patch("google_ads_mcp.tools.confirm.get_config")
@pytest.mark.asyncio
async def test_confirm_rejects_expired(mock_config, mock_store_fn):
    from google_ads_mcp.tools.confirm import confirm_change
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    store = PlanStore()
    plan = create_plan(
        tool_name="pause_campaign", customer_id="123",
        resource_name="r", entity_type="campaign", entity_name="Test",
        field="status", old_value="A", new_value="B",
        old_display="A", new_display="B", ttl_seconds=0,
    )
    store._plans[plan.plan_id] = plan  # Add directly to bypass expiry check

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test"),
        defaults=DefaultsConfig(),
    )
    mock_store_fn.return_value = store

    result = await confirm_change(plan_id=plan.plan_id)
    assert "expired" in result.lower() or "not found" in result.lower()


@patch("google_ads_mcp.tools.confirm._read_current_value")
@patch("google_ads_mcp.tools.confirm.get_plan_store")
@patch("google_ads_mcp.tools.confirm.get_config")
@pytest.mark.asyncio
async def test_confirm_rejects_stale_state(mock_config, mock_store_fn, mock_read):
    from google_ads_mcp.tools.confirm import confirm_change
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    store = PlanStore()
    plan_id = _make_status_plan(store)

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test"),
        defaults=DefaultsConfig(),
    )
    mock_store_fn.return_value = store
    mock_read.return_value = "PAUSED"  # Different from plan's old_value "ENABLED"

    result = await confirm_change(plan_id=plan_id)
    assert "changed" in result.lower() or "stale" in result.lower()


@patch("google_ads_mcp.tools.confirm.get_plan_store")
@patch("google_ads_mcp.tools.confirm.get_config")
@pytest.mark.asyncio
async def test_confirm_requires_force_for_double_confirm(mock_config, mock_store_fn):
    from google_ads_mcp.tools.confirm import confirm_change
    from google_ads_mcp.config import SafetyConfig, AppConfig, DefaultsConfig

    store = PlanStore()
    plan_id = _make_budget_plan(store, needs_double=True)

    mock_config.return_value = AppConfig(
        safety=SafetyConfig(write_passphrase="test"),
        defaults=DefaultsConfig(),
    )
    mock_store_fn.return_value = store

    result = await confirm_change(plan_id=plan_id, force=False)
    assert "force" in result.lower() or "double" in result.lower()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `pytest tests/test_confirm.py -v`
Expected: FAIL

- [ ] **Step 3: Implement confirm.py**

```python
# google_ads_mcp/tools/confirm.py
"""Confirmation tools for executing pending ChangePlans.

This is where mutations actually happen. The flow:
1. Retrieve plan from store (check not expired)
2. Re-read current state from API (stale state check)
3. Send mutation with validate_only=True (dry run)
4. If validation passes, send real mutation
5. Log to audit file
6. Remove plan from store
"""

import json
import time
from datetime import datetime, timezone
from google.ads.googleads.errors import GoogleAdsException
from google.protobuf import field_mask_pb2

from google_ads_mcp.server import mcp
from google_ads_mcp.auth import get_client
from google_ads_mcp.config import get_config
from google_ads_mcp.safety.audit_log import AuditLogger
from google_ads_mcp.safety.validators import validate_state_not_stale
from google_ads_mcp.tools.write import get_plan_store
from google_ads_mcp.tools.write_lock import is_unlocked


def _read_current_value(customer_id: str, resource_name: str, field: str, entity_type: str) -> str:
    """Read the current value of a field from the API for stale-state checking."""
    client = get_client()
    ga_service = client.get_service("GoogleAdsService")

    if entity_type == "campaign" and field == "status":
        query = f"""
            SELECT campaign.status
            FROM campaign
            WHERE campaign.resource_name = '{resource_name}'
        """
        for row in ga_service.search(customer_id=customer_id, query=query):
            return row.campaign.status.name

    if entity_type == "campaign" and field == "budget":
        query = f"""
            SELECT campaign_budget.amount_micros
            FROM campaign_budget
            WHERE campaign_budget.resource_name = '{resource_name}'
        """
        for row in ga_service.search(customer_id=customer_id, query=query):
            return str(row.campaign_budget.amount_micros)

    if entity_type == "ad_group" and field == "status":
        query = f"""
            SELECT ad_group.status
            FROM ad_group
            WHERE ad_group.resource_name = '{resource_name}'
        """
        for row in ga_service.search(customer_id=customer_id, query=query):
            return row.ad_group.status.name

    if entity_type == "ad_group" and field == "cpc_bid":
        query = f"""
            SELECT ad_group.cpc_bid_micros
            FROM ad_group
            WHERE ad_group.resource_name = '{resource_name}'
        """
        for row in ga_service.search(customer_id=customer_id, query=query):
            return str(row.ad_group.cpc_bid_micros)

    if entity_type == "keyword" and field == "status":
        query = f"""
            SELECT ad_group_criterion.status
            FROM ad_group_criterion
            WHERE ad_group_criterion.resource_name = '{resource_name}'
        """
        for row in ga_service.search(customer_id=customer_id, query=query):
            return row.ad_group_criterion.status.name

    if entity_type == "keyword" and field == "cpc_bid":
        query = f"""
            SELECT ad_group_criterion.effective_cpc_bid_micros
            FROM ad_group_criterion
            WHERE ad_group_criterion.resource_name = '{resource_name}'
        """
        for row in ga_service.search(customer_id=customer_id, query=query):
            return str(row.ad_group_criterion.effective_cpc_bid_micros)

    if entity_type == "ad" and field == "status":
        query = f"""
            SELECT ad_group_ad.status
            FROM ad_group_ad
            WHERE ad_group_ad.resource_name = '{resource_name}'
        """
        for row in ga_service.search(customer_id=customer_id, query=query):
            return row.ad_group_ad.status.name

    return ""


def _execute_mutation(customer_id: str, resource_name: str, entity_type: str,
                      field: str, new_value, validate_only: bool = False) -> str:
    """Execute the actual Google Ads API mutation."""
    client = get_client()

    if entity_type == "campaign" and field == "status":
        service = client.get_service("CampaignService")
        operation = client.get_type("CampaignOperation")
        campaign = operation.update
        campaign.resource_name = resource_name
        campaign.status = getattr(client.enums.CampaignStatusEnum, new_value)
        operation.update_mask = field_mask_pb2.FieldMask(paths=["status"])
        service.mutate_campaigns(
            customer_id=customer_id,
            operations=[operation],
            validate_only=validate_only,
        )
        return "success"

    if entity_type == "campaign" and field == "budget":
        service = client.get_service("CampaignBudgetService")
        operation = client.get_type("CampaignBudgetOperation")
        budget = operation.update
        budget.resource_name = resource_name
        budget.amount_micros = int(new_value)
        operation.update_mask = field_mask_pb2.FieldMask(paths=["amount_micros"])
        service.mutate_campaign_budgets(
            customer_id=customer_id,
            operations=[operation],
            validate_only=validate_only,
        )
        return "success"

    if entity_type == "ad_group" and field == "status":
        service = client.get_service("AdGroupService")
        operation = client.get_type("AdGroupOperation")
        ad_group = operation.update
        ad_group.resource_name = resource_name
        ad_group.status = getattr(client.enums.AdGroupStatusEnum, new_value)
        operation.update_mask = field_mask_pb2.FieldMask(paths=["status"])
        service.mutate_ad_groups(
            customer_id=customer_id,
            operations=[operation],
            validate_only=validate_only,
        )
        return "success"

    if entity_type == "ad_group" and field == "cpc_bid":
        service = client.get_service("AdGroupService")
        operation = client.get_type("AdGroupOperation")
        ad_group = operation.update
        ad_group.resource_name = resource_name
        ad_group.cpc_bid_micros = int(new_value)
        operation.update_mask = field_mask_pb2.FieldMask(paths=["cpc_bid_micros"])
        service.mutate_ad_groups(
            customer_id=customer_id,
            operations=[operation],
            validate_only=validate_only,
        )
        return "success"

    if entity_type == "keyword" and field == "status":
        service = client.get_service("AdGroupCriterionService")
        operation = client.get_type("AdGroupCriterionOperation")
        criterion = operation.update
        criterion.resource_name = resource_name
        criterion.status = getattr(client.enums.AdGroupCriterionStatusEnum, new_value)
        operation.update_mask = field_mask_pb2.FieldMask(paths=["status"])
        service.mutate_ad_group_criteria(
            customer_id=customer_id,
            operations=[operation],
            validate_only=validate_only,
        )
        return "success"

    if entity_type == "keyword" and field == "cpc_bid":
        service = client.get_service("AdGroupCriterionService")
        operation = client.get_type("AdGroupCriterionOperation")
        criterion = operation.update
        criterion.resource_name = resource_name
        criterion.cpc_bid_micros = int(new_value)
        operation.update_mask = field_mask_pb2.FieldMask(paths=["cpc_bid_micros"])
        service.mutate_ad_group_criteria(
            customer_id=customer_id,
            operations=[operation],
            validate_only=validate_only,
        )
        return "success"

    if entity_type == "ad" and field == "status":
        service = client.get_service("AdGroupAdService")
        operation = client.get_type("AdGroupAdOperation")
        ad = operation.update
        ad.resource_name = resource_name
        ad.status = getattr(client.enums.AdGroupAdStatusEnum, new_value)
        operation.update_mask = field_mask_pb2.FieldMask(paths=["status"])
        service.mutate_ad_group_ads(
            customer_id=customer_id,
            operations=[operation],
            validate_only=validate_only,
        )
        return "success"

    return f"Unknown entity_type/field combination: {entity_type}/{field}"


@mcp.tool()
async def confirm_change(plan_id: str, force: bool = False) -> str:
    """Execute a pending change plan after user approval.

    Args:
        plan_id: The plan ID returned by a write tool.
        force: Set to true to override double-confirmation requirements.

    Flow: validates plan exists -> checks stale state -> dry run -> real mutation -> audit log.
    """
    if not is_unlocked():
        return "Writes are locked. Call unlock_writes(passphrase) first."

    store = get_plan_store()
    config = get_config()
    plan = store.get(plan_id)

    if plan is None:
        return f"Plan '{plan_id}' not found or has expired. Create a new plan."

    # Double confirmation gate
    if plan.needs_double_confirm and not force:
        return (
            f"This change requires double confirmation: {plan.double_confirm_reason}\n"
            f"Call confirm_change(plan_id=\"{plan_id}\", force=true) to proceed."
        )

    # Stale state check
    start = time.time()
    try:
        current_value = _read_current_value(
            plan.customer_id, plan.resource_name, plan.field, plan.entity_type,
        )
        stale_check = validate_state_not_stale(str(plan.old_value), current_value)
        if not stale_check.is_valid:
            store.remove(plan_id)
            return f"Plan rejected: {stale_check.message}"

        # Dry run (validate_only)
        _execute_mutation(
            plan.customer_id, plan.resource_name, plan.entity_type,
            plan.field, plan.new_value, validate_only=True,
        )

        # Real mutation
        _execute_mutation(
            plan.customer_id, plan.resource_name, plan.entity_type,
            plan.field, plan.new_value, validate_only=False,
        )

        duration = int((time.time() - start) * 1000)

        # Audit log
        logger = AuditLogger(config.safety.audit_log_path)
        logger.log_write(
            tool=plan.tool_name,
            customer_id=plan.customer_id,
            resource_name=plan.resource_name,
            plan_id=plan.plan_id,
            old_value=plan.old_display,
            new_value=plan.new_display,
            result="success",
            error=None,
            duration_ms=duration,
        )

        store.remove(plan_id)
        return (
            f"Change applied successfully.\n"
            f"{plan.entity_type.title()}: {plan.entity_name}\n"
            f"{plan.field}: {plan.old_display} -> {plan.new_display}"
        )

    except GoogleAdsException as e:
        duration = int((time.time() - start) * 1000)
        error_msg = "; ".join(err.message for err in e.failure.errors)
        logger = AuditLogger(config.safety.audit_log_path)
        logger.log_write(
            tool=plan.tool_name,
            customer_id=plan.customer_id,
            resource_name=plan.resource_name,
            plan_id=plan.plan_id,
            old_value=plan.old_display,
            new_value=plan.new_display,
            result="error",
            error=error_msg,
            duration_ms=duration,
        )
        store.remove(plan_id)
        return json.dumps({
            "error": True,
            "message": error_msg,
            "request_id": e.request_id,
        }, indent=2)


@mcp.tool()
async def list_pending_plans() -> str:
    """List all pending (unexpired) change plans waiting for confirmation."""
    store = get_plan_store()
    plans = store.list_pending()

    if not plans:
        return "No pending change plans."

    lines = [f"Pending plans ({len(plans)}):"]
    for plan in plans:
        ttl = int((plan.expires_at - datetime.now(timezone.utc)).total_seconds())
        lines.append(
            f"  [{plan.plan_id}] {plan.tool_name} — "
            f"{plan.entity_name}: {plan.field} {plan.old_display} -> {plan.new_display} "
            f"(expires in {ttl}s)"
        )
    return "\n".join(lines)
```

- [ ] **Step 4: Run tests**

Run: `pytest tests/test_confirm.py -v`
Expected: All PASS

- [ ] **Step 5: Commit**

```bash
git add google_ads_mcp/tools/confirm.py tests/test_confirm.py
git commit -m "feat: add confirm_change tool with dry-run, stale-state check, and audit"
```

---

## Task 14: Write Lock MCP Tools

**Files:**
- Create: `google_ads_mcp/tools/write_lock_tools.py`

- [ ] **Step 1: Implement write_lock_tools.py (MCP tool wrappers)**

```python
# google_ads_mcp/tools/write_lock_tools.py
"""MCP tool wrappers for session write lock management."""

from google_ads_mcp.server import mcp
from google_ads_mcp.config import get_config
from google_ads_mcp.tools.write_lock import try_unlock, lock, is_unlocked


@mcp.tool()
async def unlock_writes(passphrase: str) -> str:
    """Unlock write operations for this session.

    Args:
        passphrase: The passphrase from config.yaml (safety.write_passphrase).

    Write tools are locked by default. Call this once per session to enable
    pause/enable/update operations. If no passphrase is configured, any value unlocks.
    """
    config = get_config()
    expected = config.safety.write_passphrase

    if not config.safety.write_enabled:
        return "Write operations are disabled in config.yaml (safety.write_enabled: false)."

    success = try_unlock(passphrase, expected=expected)
    if success:
        return "Writes unlocked for this session. You can now use write tools."
    return "Invalid passphrase. Writes remain locked."


@mcp.tool()
async def lock_writes() -> str:
    """Re-lock write operations for this session."""
    lock()
    return "Writes locked. Call unlock_writes(passphrase) to unlock again."


@mcp.tool()
async def write_status() -> str:
    """Check whether write operations are currently unlocked."""
    config = get_config()
    if not config.safety.write_enabled:
        return "Write operations are DISABLED in config.yaml."
    if is_unlocked():
        return "Writes are UNLOCKED for this session."
    return "Writes are LOCKED. Call unlock_writes(passphrase) to unlock."
```

- [ ] **Step 2: Commit**

```bash
git add google_ads_mcp/tools/write_lock_tools.py
git commit -m "feat: add MCP tools for session write lock management"
```

---

## Task 15: README and Documentation

**Files:**
- Create: `README.md`

- [ ] **Step 1: Write README.md**

```markdown
# Google Ads MCP Server

MCP server for Google Ads campaign management with a three-gate safety architecture. Built for use inside Claude Code.

## Safety Architecture

All write operations go through three safety gates:

1. **Session passphrase lock** — Writes are locked by default. Call `unlock_writes(passphrase)` once per session.
2. **Draft-then-confirm** — Write tools create ChangePlans (proposals), never execute directly. A separate `confirm_change(plan_id)` tool executes after explicit approval.
3. **validate_only dry-run** — Before every real mutation, the change is sent to Google with `validate_only=True`. Only if validation passes does the real mutation fire.

Additional guards:
- Budget inputs in human currency (EUR), not micros — values > 10,000 rejected as likely micros
- Budget changes capped at +/-50% per operation
- Bid changes capped at +30% per operation
- Stale-state detection (re-reads entity before applying changes)
- REMOVE operations blocked by default
- All operations logged to `~/google-ads-mcp-audit.jsonl`

## Prerequisites

- Python 3.10+
- Google Ads API credentials (developer token + OAuth)
- `google-ads.yaml` in home directory, OR environment variables

## Installation

```bash
cd google-ads-mcp-server
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -e .
```

## Configuration

Copy `config.example.yaml` to `config.yaml` and set your write passphrase:

```yaml
safety:
  write_passphrase: "your-secret-passphrase"
```

## Claude Code Setup

Add to `.claude/settings.json` or project `.mcp.json`:

```json
{
  "mcpServers": {
    "google-ads": {
      "command": "python",
      "args": ["-m", "google_ads_mcp.server"],
      "cwd": "/path/to/google-ads-mcp-server",
      "env": {
        "GOOGLE_ADS_DEVELOPER_TOKEN": "your-token",
        "GOOGLE_ADS_CLIENT_ID": "your-client-id",
        "GOOGLE_ADS_CLIENT_SECRET": "your-client-secret",
        "GOOGLE_ADS_REFRESH_TOKEN": "your-refresh-token",
        "GOOGLE_ADS_LOGIN_CUSTOMER_ID": "your-mcc-id"
      }
    }
  }
}
```

## Available Tools

### Session Management (3 tools)
| Tool | Description |
|------|-------------|
| `unlock_writes` | Unlock write operations with passphrase |
| `lock_writes` | Re-lock write operations |
| `write_status` | Check if writes are locked or unlocked |

### Read Tools (9 tools)
| Tool | Description |
|------|-------------|
| `list_accounts` | List all accounts under MCC |
| `list_campaigns` | List campaigns for an account |
| `get_campaign` | Full detail for one campaign |
| `list_ad_groups` | List ad groups in a campaign |
| `get_campaign_metrics` | Performance metrics for a campaign |
| `get_account_metrics` | Account-level performance metrics |
| `list_keywords` | List keywords in an ad group |
| `list_ads` | List ads in an ad group |
| `run_gaql` | Execute arbitrary read-only GAQL query |

### Write Tools (11 tools) — all create ChangePlans, never mutate directly
| Tool | Description |
|------|-------------|
| `pause_campaign` | Propose pausing a campaign |
| `enable_campaign` | Propose enabling a campaign |
| `update_campaign_budget` | Propose new daily budget (in EUR) |
| `pause_ad_group` | Propose pausing an ad group |
| `enable_ad_group` | Propose enabling an ad group |
| `update_ad_group_bid` | Propose new default CPC bid (in EUR) |
| `pause_keyword` | Propose pausing a keyword |
| `enable_keyword` | Propose enabling a keyword |
| `update_keyword_bid` | Propose new CPC bid for a keyword (in EUR) |
| `pause_ad` | Propose pausing an ad |
| `enable_ad` | Propose enabling an ad |

### Confirmation Tools (2 tools)
| Tool | Description |
|------|-------------|
| `confirm_change` | Execute a pending ChangePlan |
| `list_pending_plans` | Show all unexpired ChangePlans |

## Write Flow Example

```
User: "Set Brand - NL budget to 75 EUR/day"

1. Claude calls: update_campaign_budget(customer_id="123", campaign_id="456", new_daily_budget=75.0)
2. Server returns: "PROPOSED: budget 50.00/day -> 75.00/day (+50%). Plan ID: abc-123"
3. Claude shows plan to user, asks for confirmation
4. User approves
5. Claude calls: confirm_change(plan_id="abc-123", force=true)
6. Server: dry-run -> validate -> execute -> log -> "Change applied successfully"
```

## Running Tests

```bash
pip install -e ".[dev]"
pytest -v
```
```

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: add README with safety architecture, setup, and tool catalog"
```

---

## Task 16: Plugin Reference Updates

**Files:**
- Modify: `../ad-platform-campaign-manager/reference/mcp/mcp-comparison.md`
- Modify: `../ad-platform-campaign-manager/reference/mcp/claude-settings-template.md`
- Modify: `../ad-platform-campaign-manager/PLAN.md`

- [ ] **Step 1: Update mcp-comparison.md**

Add a new entry for the custom server at the top of the "Available MCP Servers" section:

```markdown
### voxxy/google-ads-mcp-server (Custom — Read + Write + Safety)
- **Location:** Local — `../google-ads-mcp-server/`
- **Language:** Python
- **Access:** Read + Write with three-gate safety architecture
- **Features:**
  - 9 read tools (accounts, campaigns, ad groups, metrics, keywords, ads, GAQL)
  - 11 write tools with draft-then-confirm (pause/enable, budgets, bids)
  - Session passphrase lock
  - validate_only dry-run before every mutation
  - Budget/bid caps, stale-state detection, REMOVE blocked
  - JSON audit log of all operations
- **Auth:** OAuth2 via google-ads.yaml or environment variables
- **Best for:** Safe campaign management from Claude Code with full audit trail
```

Update the "Recommended Setup" section to point to the custom server.

- [ ] **Step 2: Update claude-settings-template.md**

Add the custom server config block.

- [ ] **Step 3: Update PLAN.md**

Add Phase 3 sub-steps and update status.

- [ ] **Step 4: Commit in ad-platform-campaign-manager**

```bash
cd ../ad-platform-campaign-manager
git add reference/mcp/mcp-comparison.md reference/mcp/claude-settings-template.md PLAN.md
git commit -m "docs: update MCP references for custom google-ads-mcp-server"
```

---

## Task 17: Run Full Test Suite and Verify

- [ ] **Step 1: Run all unit tests**

```bash
cd ../google-ads-mcp-server
pytest -v
```

Expected: All tests pass.

- [ ] **Step 2: Verify server starts**

```bash
python -m google_ads_mcp.server --help
```

Or test with MCP inspector if available.

- [ ] **Step 3: Verify tool registration**

Start server and verify all 25 tools appear:
- 3 session management (unlock_writes, lock_writes, write_status)
- 9 read tools
- 11 write tools
- 2 confirmation tools

- [ ] **Step 4: Manual smoke test against test account (when credentials available)**

1. Run `list_accounts` — verify output format
2. Run `list_campaigns` — verify campaign data
3. Run `write_status` — verify "LOCKED"
4. Try `pause_campaign` while locked — verify rejection
5. Run `unlock_writes` with correct passphrase — verify unlock
6. Run `pause_campaign` — verify ChangePlan returned (not executed)
7. Run `confirm_change` — verify mutation succeeds
8. Check `~/google-ads-mcp-audit.jsonl` — verify log entry

- [ ] **Step 5: Final commit**

```bash
git add -A
git commit -m "chore: complete google-ads-mcp-server v0.1.0"
```
