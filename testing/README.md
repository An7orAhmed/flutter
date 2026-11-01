# Impeller Web testing

This folder is a fork-only test protocol. The goal is to verify the existing experimental Wimp implementation and reproduce the queued-picture lifetime regression in flutter/flutter#193696 without introducing timing-dependent test behavior.

Follow ../AGENTS.md and official Flutter engine guidance first. Never include this testing/ directory in an upstream Flutter pull request.

## Preflight

From the repository root on the dev branch:

~~~sh
git switch dev
git status --short
git rev-parse HEAD
git remote -v
git diff --check
~~~

Confirm the local checkout is on dev, clean, and contains the expected test files. Record the commit SHA and host environment in RESULTS.md. Ensure gclient, depot_tools, Dart from the Flutter checkout, Emscripten SDK and a test browser are available.

For first-time setup, follow the official instructions, do not invent environment-specific setup commands:

- https://github.com/flutter/flutter/blob/master/docs/engine/contributing/Setting-up-the-Engine-development-environment.md
- https://github.com/flutter/flutter/blob/master/engine/src/flutter/lib/web_ui/README.md

Flutter's engine/scripts/standard.gclient must be copied to .gclient, and download_emsdk must be enabled before gclient sync for Web builds. Install/verify the toolchain before running tests. Wimp is experimental and uses the Skwasm infrastructure and browser WebGL.

## Validate formatter and tests

From the repository root:

~~~sh
dart format --output=none --set-exit-if-changed engine/src/flutter/lib/web_ui/test/skwasm/wimp_smoke_test.dart
dart format --output=none --set-exit-if-changed engine/src/flutter/lib/web_ui/test/ui/async_rendering_test.dart
git diff --check
~~~

Do not accept formatter differences without inspecting them. If Dart is not on PATH, use the toolchain provisioned by the Flutter engine checkout. A successful static check is not a successful runtime test.

From engine/src/flutter/lib/web_ui, expose the felt tool, then inspect available suites and build artifacts:

~~~sh
export PATH="$PWD/dev:$PATH"
felt help
felt test --list --suite chrome-dart2wasm-wimp-ui
felt build sdk wimp skwasm
~~~

If the checked-out Flutter revision uses different felt options, check felt help and upstream documentation and update these instructions. For Web engine test failures, record the full failure rather than assuming a test bug.

## Required test matrix

| ID | Suite | Test file | Expected behavior before a fix |
| --- | --- | --- | --- |
| WIMP-01 | chrome-dart2wasm-wimp-skwasm | test/skwasm/wimp_smoke_test.dart | Both Wimp tests should complete and expected pixels should match |
| QUEUE-01 | chrome-dart2wasm-wimp-ui | test/ui/async_rendering_test.dart | The new queued-picture assertion is expected to fail on unfixed upstream if the issue reproduces |
| QUEUE-02 | chrome-coi-dart2wasm-skwasm-ui | test/ui/async_rendering_test.dart | Same regression expectation in Skwasm |
| BASE-01 | chrome-dart2wasm-wimp-ui | test/ui/async_rendering_test.dart | All existing unrelated async rendering tests should remain stable |
| BASE-02 | chrome-coi-dart2wasm-skwasm-skwasm | test/skwasm/native_memory_test.dart | Existing native memory tests must keep passing |

Run these from the Web UI directory:

~~~sh
felt test --suite chrome-dart2wasm-wimp-skwasm test/skwasm/wimp_smoke_test.dart
felt test --suite chrome-dart2wasm-wimp-ui test/ui/async_rendering_test.dart
felt test --suite chrome-coi-dart2wasm-skwasm-ui test/ui/async_rendering_test.dart
felt test --suite chrome-coi-dart2wasm-skwasm-skwasm test/skwasm/native_memory_test.dart
~~~

The queued-picture test is intentionally written to express the desired behavior. It is **not** known to fail until a runtime result demonstrates the failure. If it passes unexpectedly, inspect whether the fake rasterizer actually waited and whether the queued scene was rasterized after the retained layer was disposed.

## What to inspect

1. Verify the browser actually selected Wimp for WIMP-01 rather than silently using CanvasKit or Skwasm. Check the named suite and the isWimp guard.
2. Check image readback format, pixel color expectations, disposal/cleanup, and test stability across repeated Wimp runs.
3. During queued-frame tests, verify the first render is gated, the second request goes into renderQueue.next, and disposing the old OffsetEngineLayer removes the picture before deferred preroll. Capture the relevant assertion and trace, not only the final status.
4. Confirm unrelated async frame and platform-view tests still pass. Investigate other failures before claiming a regression fix.
5. Re-run tests after any renderer changes, including CanvasKit controls when the shared renderer is modified.
6. For larger renderer proposals, check Chrome, Firefox and Safari only where the target feature and suite are supported; do not infer full Wimp browser compatibility.

Do not generate artificial raster timestamps for dropped frames without agreement on the semantics of FrameTimingRecorder. The reported queued-picture lifetime bug and missing timings for discarded frames are separate concerns.

## Evidence and signoff

Update testing/RESULTS.md after actual execution. For each test include exact commit SHA, operating system, browser version, toolchain, full command, observed result, failure signature or successful assertion, and relevant logs or screenshots. Use NOT RUN when blocked. Never label expected failure as an observed failure.

Before preparing an upstream PR: reproduce the bug, make the minimum fix, run targeted and relevant regression tests, review changed code and PR description personally, and create a clean branch from current flutter/flutter master. An upstream PR must not contain AGENTS.md or testing/ files.
