# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Breaking Changes
- **feat: implement robust error handling and IDE integration** (2025-07-08 – jarroddavis68)
  Add comprehensive error management system with stop-on-error control
  and enhanced semantic analysis capabilities.
  - Implement error count synchronization across all compiler phases
  - Add enhanced source location tracking with line content context
  - Create warning categorization system with 8 distinct categories
  - Add configurable error limits (MaxErrors, StopOnFirstError, StrictMode)
  - Implement immediate error recovery preventing cascading failures
  - Add sophisticated data flow analysis with variable usage tracking
  - Implement uninitialized variable detection with assignment validation
  - Add unused variable detection and performance analysis
  - Create deprecated feature detection with actionable hints
  - Expand callback system with OnAnalysis for real-time code insights
  - Add OnStartup/OnShutdown lifecycle management
  - Implement structured error reporting with source context
  - Expand test suite from 22 to 33 comprehensive tests (50% increase)
  - Add dedicated error handling and warning system validation
  - Implement performance benchmarking and regression prevention
  Advances implementation from basic foundation to 35/144 BNF rules
  (24.3% complete). All 33 tests pass with 100% success rate.
  Breaking changes: None


### Added
- **Update README.md** (2025-07-14 – jarroddavis68)
  - Fixed LICENCE link
  - Added CPascal homepage link

- **feat(compiler): Implement Phase 2 Procedures, Functions & Loop Control** (2025-07-02 – jarroddavis68)
  Completes all Phase 2 tasks by adding full support for subroutines and advanced loop control statements.
  - Implements functions and procedures with support for value, `var`, and `const` parameters.
  - Adds `external` function declarations and all BNF-specified calling conventions (`cdecl`, `stdcall`, `fastcall`, `register`) for C ABI interoperability.
  - Adds support for `break` and `continue` statements with contextual validation.
  - Fixes memory corruption and dangling pointer bugs by implementing correct ownership semantics for parameter symbols in the symbol table.
  - Corrects parser logic for statement separator handling.
  - Updates `coverage.pas` with comprehensive tests for all new capabilities.

- **feat(compiler): Finalize core features and align test suites** (2025-07-01 – jarroddavis68)
  This major update implements foundational control flow structures, a comprehensive C-compatible type system, and a robust callback architecture. This commit also finalizes the implementation by correcting the lexer for full BNF conformance and aligning the entire test suite with the new type system.
  - Implemented if-then-else, while-do, repeat-until, and for-to/downto loops.
  - Replaced the generic Integer type with the full set of Int8/16/32/64 and UInt8/16/32/64 types.
  - Implemented implicit numeric conversions (narrowing and widening) for integers and floats.
  - Added support for signed vs. unsigned arithmetic and comparisons in the IR generator.
  - Corrected the lexer to fully support both $ and 0x prefixed hexadecimal literals, ensuring BNF conformance.
  - Updated the entire test suite (Lexer, Parser, Semantic, IRGen, Compiler) to use the new specific-width type system.
  - Refactored the IR generator's binary operator handling to resolve compiler warnings and improve robustness.
  - Updated project documentation, including TODO.md to reflect current progress and README.md for better clarity.
  - Generated a new, comprehensive test report validating that all 22 tests pass, confirming system stability.
  - Introduced a new CPascal.Common unit to resolve a circular reference and hold shared types.
  - Added OnProgress, OnError, and OnWarning callbacks to the main TCPCompiler class.
  - Implemented a custom ECPCompilerError exception to pass structured error data.
  - The semantic analyzer now collects and reports warnings for issues like narrowing conversions.

- **Repo Update** (2025-06-29 – jarroddavis68)
  - Added documentation (language bnf, specification, coverage, api reference, c migration)

- **Create FUNDING.yml** (2025-06-29 – Jarrod Davis)


### Changed
- **Merge branch 'main' of https://github.com/tinyBigGAMES/CPascal** (2025-07-16 – jarroddavis68)

- **PHASE 1 COMPLETE: SSA Layer** (2025-07-16 – jarroddavis68)

- **Merge branch 'main' of https://github.com/tinyBigGAMES/CPascal** (2025-07-01 – jarroddavis68)

- **Repo Update** (2025-07-01 – jarroddavis68)
  - Updated README to display local badge images

- **Merge branch 'main' of https://github.com/tinyBigGAMES/CPascal** (2025-07-01 – jarroddavis68)

- **Update README.md** (2025-07-01 – jarroddavis68)

- **Merge branch 'main' of https://github.com/tinyBigGAMES/CPascal** (2025-07-01 – jarroddavis68)

- **Update README.md** (2025-07-01 – jarroddavis68)

- **Merge branch 'main' of https://github.com/tinyBigGAMES/CPascal** (2025-07-01 – jarroddavis68)

- **Initial commit** (2025-06-29 – Jarrod Davis)


### Fixed
- **Merge pull request #5 from norayr/main** (2025-07-14 – Jarrod Davis)
  fixed links.

- **fixed links.** (2025-07-15 – Norayr Chilingarian)

