# Impeller Web contribution workspace

This is the persistent development context for the Impeller Web contribution effort in the fork `An7orAhmed/flutter`.

**Scope:** Fork-only agent instructions and project memory. This file is canonical on the `dev` integration branch. It must not be included in a pull request to `flutter/flutter` unless Flutter maintainers explicitly request it. Flutter's AI contribution policy identifies irrelevant agent planning Markdown files as a reason to close a pull request.

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
5. Work on `dev` for integrated development. Create fresh upstream contribution branches from current upstream `master` (or the maintainer-requested base), never from `dev`. Copy only verified relevant source commits or changes. Avoid unrelated commits.
6. Match the nearby Flutter source conventions and official style guide. Prefer readable, efficient changes and meaningful names. For Dart, use the repository's formatter. For C++ and other files, use Flutter's applicable formatters and lint tools. Follow upstream conventions over personal preferences.
7. Add deterministic, scoped tests that reproduce the issue or verify behavior. Prefer meaningful assertions over tests that merely run without throwing. Run the relevant local tests and analysis; report exact commands, results, environment, and limitations. Never claim a build or test passed without executing it.
8. Review and understand every AI-assisted source change before sending it upstream. Verify all PR descriptions and review responses. Do not submit unreviewed AI output or let automation stand in for human discussion.
9. Respect Flutter's code of conduct, tree hygiene, Google CLA requirements, and normal review process. Follow the current PR template. As documented on 2026-11-01, contributors without write access are limited to two concurrent non-draft PRs per repository.
10. Ask for explicit approval before opening an upstream PR or posting substantive comments on behalf of the contributor. Never automatically merge or bypass review.
11. Keep this context factual. Distinguish verified facts, decisions, hypotheses, proposed tasks, and unfinished work. Never invent measurements, test outcomes, author approvals, or issue states.
12. At the end of a session, update this file and testing/RESULTS.md on `dev` with verified outcomes, related links, next actions, and unresolved questions. Do not commit fork-only memory and test planning files to upstream PR branches.

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

## Branch model and current work (2026-11-01)

The **dev** branch is the long-lived integration branch for this fork. It contains all ongoing source/test changes, this AGENTS.md, and the fork-local testing/ folder. Always read this document and testing/README.md at the start of a new session. Keep dev up to date as work evolves.

Never use dev as the head of a PR against flutter/flutter. Dev includes fork-only agent context, testing documentation, and intentionally unverified or expected-failing regression tests. A clean upstream contribution branch must be created independently from current flutter/flutter master, containing only verified source changes relevant to the selected issue.

**Integrated source work:**

- Wimp smoke tests from impeller-web-smoke-test: engine/src/flutter/lib/web_ui/test/skwasm/wimp_smoke_test.dart. Includes 30-frame path/text rendering and known color pixel-readback assertions. Needs execution and validation.
- Queued-picture regression from web-queued-picture-regression: engine/src/flutter/lib/web_ui/test/ui/async_rendering_test.dart. Exercises the scene queue, retained offset-layer disposal and expected paintable queued picture, scoped to Skwasm/Wimp. The test is expected to reveal flutter/flutter#193696 but a red run has not been observed yet.
- This AGENTS.md was initially maintained on impeller-web-context. On dev it is now the canonical context. The old branch is historical and may become stale.
- testing/README.md is the test plan; testing/AGENTS.md defines the agent test protocol; testing/RESULTS.md records observed results. These are fork-only files.

**Verification status:** Source has been inspected through GitHub, but no actual felt test, Dart format, Dart analyze, GPU run, or browser test has been executed for the new tests. No upstream PR has been opened. Do not claim passing tests or a reproduced failure without running the commands.

**Current next actions:**

1. Set up the Flutter engine web build prerequisites per upstream docs: depot_tools, gclient, download_emsdk, and Chrome.
2. Run the Wimp and Skwasm UI tests listed in testing/README.md. Capture branch and exact commit SHA, command and output.
3. Confirm the queued picture regression fails for the expected assertion and not for harness or initialization errors. The intended existing behavior is first-frame rendering, queueing the next frame, and disposing the previous engine layer before its raster pass.
4. After a verified failure, design the smallest change to retain queued scene picture handles correctly. Keep the separate frame timing recorder issue distinct and seek maintainer guidance on timings for intentionally dropped frames.
5. Avoid opening upstream PRs for fork-local planning files, test code that has not been verified, or unrelated changes.

## Session log

### 2026-11-01

- Confirmed `An7orAhmed/flutter` is available as a fork of Flutter and that the fork's `master` matched upstream `master` at inspection.
- Inspected Wimp sources, build targets, JavaScript loader, and `felt` test suites.
- Created `impeller-web-smoke-test` and a first Wimp rendering smoke test. The test has not been verified locally.
- Confirmed Flutter's AI contribution policy specifically discourages unrelated agent planning Markdown files in upstream PRs.
- Created separate `impeller-web-context` branch to preserve agent instructions and project memory without polluting upstream contributions.

### 2026-11-01 (continued)

- Re-read this file and verified the fork and upstream `master` matched at commit `fcfb4f203eae4a47807697f02b99251994e2ab21`.
- Inspected the existing Wimp smoke test, renderer queue, Wimp issues, and relevant existing rendering tests.
- Added a deterministic `Picture.toImageSync` pixel readback test to `impeller-web-smoke-test`. It checks white background pixels and a blue horizontal stroked path under Wimp. Verified the source commit and inspected the diff; implementation branch changes only `wimp_smoke_test.dart`.
- Final source commit at inspection: `91c4b07e08a2bf66aa949adbcba16aae63106be3`.
- Did not run `felt`, Dart formatter, or browser tests. The available environment has no Flutter checkout/Dart SDK and cannot clone from GitHub through the container network.
- Investigated open issue https://github.com/flutter/flutter/issues/193696 concerning queued frames and dropped timing records; no fix has been implemented. The current timing recorder requires build and raster timestamps, so fabricating values for skipped frames without a specified contract is unsafe.
- No upstream PR or maintainer comment was created. Local test validation and human review remain required.

### 2026-11-01 (queued frame reproduction)

- Read this context, inspected `flutter/flutter#193696`, and confirmed that the fork and upstream `master` were at `fcfb4f203eae4a47807697f02b99251994e2ab21`.
- Inspected `renderer.dart`, `LayerSceneBuilder`, `PrerollVisitor`, `ContainerLayer.dispose()`, and existing async rendering test helpers.
- Created `web-queued-picture-regression` directly from fork `master`, separate from Wimp smoke tests and this context branch.
- Added an asynchronous test in `engine/src/flutter/lib/web_ui/test/ui/async_rendering_test.dart` to deterministically queue a scene behind a blocked first render, dispose a previously retained offset layer, and assert that the queued scene still paints. The test uses an existing `TestRasterizer` subclass for the paintability observation and is skipped outside Skwasm/Wimp.
- Last verified change commit: `332b37ed4d0b3b45bd375f9b2d1207be214c01af`. Comparison against fork `master` showed one modified file and no unrelated context files.
- Only static verification was performed; the regression test has not been run and its expected failure has not been observed. Do not call the bug reproduced by execution yet. Do not submit the intentionally failing test upstream without a fix or maintainer agreement.
- Next: configure the engine build, run `felt build sdk wimp`, run Wimp and Skwasm UI suites on this branch, capture any failure, then work on the actual renderer fix if confirmed.

### 2026-11-01 (dev integration)

- Created dev from fork master at fcfb4f203eae4a47807697f02b99251994e2ab21, matching upstream master at inspection.
- Integrated the latest Wimp smoke and queued-picture test file snapshots from their existing branches, without adding code changes or claiming test execution.
- Added testing/ documentation and consolidated this file as the canonical project memory on dev. The original standalone feature branches remain as separate historical workstreams.
- dev is an integration workspace, not an upstream PR branch. Testing documentation and AGENTS.md must be excluded from upstream PRs.

## Maintaining this file

Read this canonical dev context on every session:

~~~sh
git fetch origin dev
git show origin/dev:AGENTS.md
git show origin/dev:testing/README.md
~~~

Use the equivalent GitHub API paths on ref dev when working remotely. Update the dev branch after each meaningful session with precise completed work, changed file paths, commit SHAs, test commands/results, blockers, and next tasks. Keep test outcomes in testing/RESULTS.md. Do not treat the historical impeller-web-context branch as canonical.

Before upstream PR work, start a separate branch from the latest upstream master and copy or cherry-pick only focused, reviewed source changes and regression tests. Do not merge dev into an upstream PR branch.
