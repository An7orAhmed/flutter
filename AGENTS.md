# Impeller Web contribution workspace

This is the persistent development context for the Impeller Web contribution effort in the fork `An7orAhmed/flutter`.

**Scope:** Fork-only agent instructions and project memory. This file belongs on the `impeller-web-context` branch. It must never be included in a pull request to `flutter/flutter` unless Flutter maintainers explicitly request it. Flutter's AI contribution policy identifies irrelevant agent planning Markdown files as a reason to close a pull request.

**Last reviewed:** 2026-11-01. Facts below are a snapshot, not a claim that subsequent work has been completed.

## Mission

Help land small, correct, maintainable Impeller Web (Wimp) improvements in the upstream Flutter repository, `flutter/flutter`. Work with the existing Flutter Web engine and Wimp implementation. Do not create a separate renderer fork or introduce a WebGPU backend until the existing design, use cases, and maintainer feedback justify it.

Success is upstream-quality reviewed contributions, not a fork-only demonstration or simply generating code.

## Repository and reference links

- Contributor fork: https://github.com/An7orAhmed/flutter
- Upstream: https://github.com/flutter/flutter
- Fork default branch: `master`
- Wimp tracking issue: https://github.com/flutter/flutter/issues/174980
- Initial Wimp implementation: https://github.com/flutter/flutter/pull/175442
- Flutter contributing guide: https://github.com/flutter/flutter/blob/master/CONTRIBUTING.md
- Flutter AI contribution policy: https://github.com/flutter/flutter/blob/master/CONTRIBUTING.ai.md
- Tree hygiene: https://github.com/flutter/flutter/blob/master/docs/contributing/Tree-hygiene.md
- Flutter style guide: https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md
- Engine setup: https://github.com/flutter/flutter/blob/master/docs/engine/contributing/Setting-up-the-Engine-development-environment.md
- Web engine setup and `felt`: https://github.com/flutter/flutter/blob/master/engine/src/flutter/lib/web_ui/README.md

Consult current upstream files before acting. Requirements, implementation details, and issue status can change.

## Instructions for every coding agent

1. Read this file and the relevant upstream contribution guides before starting work. Fetch current upstream sources rather than relying only on this snapshot.
2. Verify the current fork branch, upstream head, exact file contents, open issues, and any related PRs. Do not assume a planned change is not already implemented.
3. Select a narrow, reproducible bug, test gap, or maintainable feature. Check for duplicate issues and PRs; discuss significant architectural changes with maintainers before coding. Use the Flutter RFC process when appropriate.
4. Keep upstream submissions limited to the related source code, tests, and necessary product documentation. Never include this `AGENTS.md`, personal notes, agent prompts, scratch files, or unrelated files.
5. Create a fresh contribution branch from the current upstream `master` (or the base requested by maintainers). Never base an upstream PR on this context branch. Avoid unrelated commits in the patch.
6. Match the nearby Flutter source conventions and official style guide. Prefer readable, efficient changes and meaningful names. For Dart, use the repository's formatter. For C++ and other files, use Flutter's applicable formatters and lint tools. Follow upstream conventions over personal preferences.
7. Add deterministic, scoped tests that reproduce the issue or verify behavior. Prefer meaningful assertions over tests that merely run without throwing. Run the relevant local tests and analysis; report exact commands, results, environment, and limitations. Never claim a build or test passed without executing it.
8. Review and understand every AI-assisted source change before sending it upstream. Verify all PR descriptions and review responses. Do not submit unreviewed AI output or let automation stand in for human discussion.
9. Respect Flutter's code of conduct, tree hygiene, Google CLA requirements, and normal review process. Follow the current PR template. As documented on 2026-11-01, contributors without write access are limited to two concurrent non-draft PRs per repository.
10. Ask for explicit approval before opening an upstream PR or posting substantive comments on behalf of the contributor. Never automatically merge or bypass review.
11. Keep this context factual. Distinguish verified facts, decisions, hypotheses, proposed tasks, and unfinished work. Never invent measurements, test outcomes, author approvals, or issue states.
12. At the end of a working session, update this file on the `impeller-web-context` branch with the outcome, next actions, related links, and unresolved questions. Do not commit memory changes to feature branches.

## Development preferences

The contributor prefers clean, efficient, readable code with meaningful names and two-space indentation where compatible with Flutter style. Avoid unnecessary comments, but retain required license headers, documentation, and explanations mandated by upstream rules. Favor small, reviewable patches. Keep PR and review writing concise and natural. The contributor must personally understand and verify submitted AI-assisted code.

## Architecture snapshot

Flutter Web currently uses CanvasKit or Skwasm as its established rendering options. The experimental Impeller Web path, called **Wimp**, already exists in the Flutter engine. It uses WebAssembly and WebGL integration through the Skwasm infrastructure. Do not present Wimp as an officially supported, production-ready WebGPU renderer.

Useful locations relative to the repository root:

- `engine/src/flutter/skwasm/`: WebAssembly rendering adapters and Wimp implementation.
- `engine/src/flutter/skwasm/render_context_impeller.cc`: Wimp rendering context.
- `engine/src/flutter/skwasm/shaders_impeller.cc`: Impeller runtime effect adapter; inspect current TODOs before modifying.
- `engine/src/flutter/skwasm/BUILD.gn`: Wimp-related C++ build configuration.
- `engine/src/flutter/impeller/`: native Impeller implementation.
- `engine/src/flutter/lib/web_ui/`: Dart and JavaScript Web engine integration.
- `engine/src/flutter/lib/web_ui/flutter_js/src/skwasm_loader.js`: chooses Wimp variants when enabled.
- `engine/src/flutter/lib/web_ui/test/felt_config.yaml`: browser, renderer and test suite definitions.
- `engine/src/flutter/lib/web_ui/dev/build.dart`: `wimp` and `wimp_heavy` build targets.

WebGPU is an optional future research direction, **not** an implemented project milestone. Any WebGPU proposal needs architectural discussion, browser support review, shader strategy, benchmarks, and maintainer feedback.

## Local development and validation

Follow the official engine setup documentation for depot_tools and `gclient`. Use `engine/scripts/standard.gclient` as the basis for `.gclient`, enable `download_emsdk` for Web engine builds, and run `gclient sync`. Verify the requirements for the host operating system.

The Web engine uses `felt`. In the Web UI directory, relevant candidate commands include:

```sh
felt help
felt build sdk wimp
felt test --list --suite chrome-dart2wasm-wimp-skwasm
felt test --suite chrome-dart2wasm-wimp-skwasm test/skwasm/wimp_smoke_test.dart
```

These are candidate commands, not verified passing commands. Validate build prerequisites and `felt` arguments against the checked-out revision. Compare Wimp behavior against Skwasm where appropriate and report which renderer actually ran.

## Current work snapshot (2026-11-01)

**Current implementation branch:** `impeller-web-smoke-test` in `An7orAhmed/flutter`.

**Existing change:** `engine/src/flutter/lib/web_ui/test/skwasm/wimp_smoke_test.dart`. A first smoke test renders a paragraph and multiple path traces over 30 frames, using the existing Wimp test gate. Its inspiration was to exercise repeated path and text rendering; it is not yet a demonstrated fix for a specific upstream regression.

**Known limitations:** No local build or test run was verified in this conversation. The test only verifies successful rendering completion, without checking output pixels or other strong assertions. Its usefulness and design need human review before a PR. Do not claim that a PR has been opened or that the code is ready to merge.

**Upstream status:** Wimp tracking issue `flutter/flutter#174980` was open when checked. Wimp implementation and test configuration already exist upstream.

**Context branch:** `impeller-web-context` is reserved for this file and its ongoing updates. The implementation branch and fork's `master` must stay free of these context-only commits.

## Immediate next tasks

1. Set up and verify the local Web engine build environment.
2. Run the existing Wimp tests and the smoke test. Capture exact command lines and pass/fail output.
3. Evaluate whether the smoke test adds value over existing coverage; if not, revise or discard it rather than submitting a weak PR.
4. Identify a specific currently reproducible Wimp bug or missing test with a relevant upstream issue.
5. Create a small fix with a regression test, verify locally, and prepare an accurate upstream PR for human review.

## Session log

### 2026-11-01

- Confirmed `An7orAhmed/flutter` is available as a fork of Flutter and that the fork's `master` matched upstream `master` at inspection.
- Inspected Wimp sources, build targets, JavaScript loader, and `felt` test suites.
- Created `impeller-web-smoke-test` and a first Wimp rendering smoke test. The test has not been verified locally.
- Confirmed Flutter's AI contribution policy specifically discourages unrelated agent planning Markdown files in upstream PRs.
- Created separate `impeller-web-context` branch to preserve agent instructions and project memory without polluting upstream contributions.

## Maintaining this file

At the beginning of each session, read:

```sh
git fetch origin impeller-web-context
git show origin/impeller-web-context:AGENTS.md
```

These commands let an agent inspect the context without switching to the context branch or adding it to a contribution. If working through the GitHub API instead, fetch `AGENTS.md` from ref `impeller-web-context` in `An7orAhmed/flutter`.

At the end of each actual work session, update the relevant sections and append a short dated session log entry with verified changes, branch or PR links, tests run and their results, blockers, and next steps. Preserve durable decisions, avoid duplicate prose, and correct stale facts. Only publish updates that reflect real progress.
