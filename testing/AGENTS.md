# Agent testing instructions

These instructions apply to the fork-only testing/ folder in the dev integration branch.

1. Read ../AGENTS.md, README.md, RESULTS.md and the current upstream Flutter contribution rules before choosing tests.
2. Use the exact source revision checked out. Confirm actual engine options and suites with felt help and felt test --list.
3. Prioritize WIMP-01 and QUEUE-01/QUEUE-02 in README.md. Distinguish the known expected red assertion in the queued-picture regression from an actually observed failing run.
4. Do not change production engine code just to make an unverified test pass. Reproduce failures deterministically and understand the ownership of retained layer pictures.
5. Record results only after commands execute, including environment, commit, browser, exact commands, logs and the first meaningful failure. Never invent passing runs.
6. After modifying code on dev, repeat the relevant tests and report any regressions. For upstream submission use a clean feature branch and exclude the entire testing/ folder and root AGENTS.md.
7. Keep README.md and RESULTS.md current when test suites or expectations change. Preserve incomplete and blocked history rather than overwriting it with assumptions.
