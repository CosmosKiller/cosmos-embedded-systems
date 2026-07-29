# Cosmos code style

Conventions for firmware written in this repo. They apply to **project code we write**.

When calling framework or third-party APIs (ESP-IDF, Zephyr, vendor SDKs, etc.), follow upstream naming at the boundary; use Cosmos rules inside our modules.

**Language:** English only for comments and docs aimed at the team.

## Formatting (clang-format)

Style is **LLVM-based** with **Linux** brace breaks (opening brace on the same line except function definitions), **4-space** indents, no tabs, and aligned consecutive macros.

A repo-root `.clang-format` should encode this. Format before commit:

```bash
./tools/scripts/format_sources.sh
# or: clang-format -i path/to/file.cpp
```

### Editor

1. Install a C/C++ extension with clang-format support.
2. Prefer **clang_format_style: file** (repo `.clang-format`).
3. Enable format on save for C/C++.

Suggested fallback style if no file is present:

```
{ BasedOnStyle: LLVM, UseTab: Never, IndentWidth: 4, TabWidth: 4, BreakBeforeBraces: Linux, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, ColumnLimit: 0, AccessModifierOffset: -4, NamespaceIndentation: All, FixNamespaceComments: false, AlignConsecutiveMacros: true }
```

Repo defaults: `.editorconfig` (indent 4, UTF-8).

## Naming

| Kind | Convention | Example |
|------|------------|---------|
| Variables, functions | `snake_case` | `binary_sensor_task_init` |
| Pointer variables | `camelCase` with leading `p` | `device_ctx_t *pSocket` |
| `typedef struct` | `snake_case` + `_t` suffix | `binary_sensor_ctx_t` |
| `typedef enum` | `snake_case` + `_e` suffix | `evt_source_e` |
| Enum members | `UPPER_SNAKE_CASE` | `EVT_SOURCE_ALARM` |
| Macros / `#define` | `UPPER_SNAKE_CASE` | `SINGLE_PRESS_LED_PIN` |

## Comments

- **Single line:** `//`
- **Multi-line:** `/* ... */` with a `*` prefix on each line, lines aligned:

```c
/*
 * This is a multi-line comment.
 * Keep line lengths even where practical.
 */
```

## Documentation (Doxygen)

Public APIs in shared headers should use Doxygen blocks.

**Functions / files:** `/** ... */` with `@brief`, `@param`, `@return`, `@note` as needed.

```c
/**
 * @brief Initialize the binary sensor GPIO and ISR wiring.
 *
 * @param config Driver config including callback.
 * @return 0 on success, or a negative error code / framework error type.
 */
int binary_sensor_task_init(binary_sensor_config_t *config);
```

**Struct / enum / `#define` members:** trailing `/*!< description */` on the same line when short:

```c
typedef struct {
    const char sn[15]; /*!< Device serial number */
    int state;         /*!< Initial line level (0 low, 1 high) */
} device_ctx_t;

#define NO_OF_SAMPLES 64 /*!< ADC multisample count */
```

File headers should include `@file`, `@brief`, and copyright where the project already uses them.

## Layout

Follow [REPO_LAYOUT.md](REPO_LAYOUT.md) for where headers and sources live. Prefer **1:1 basename** between public header and implementation for app-local modules.
