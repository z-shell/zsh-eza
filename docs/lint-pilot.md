# Shared lint pilot

The [pilot workflow](../.github/workflows/zsh-lint-pilot.yml) qualifies the shared reporting wrapper under [issue #126](https://github.com/z-shell/zsh-eza/issues/126). It runs on every pull request targeting `main`, including documentation-only changes and forks, and every push to `main`.

The explicit [configuration](../zsh-lint.json) retains the repository's Zsh 5.9.2 compatibility floor and these source profiles:

| Source                    | Profile             |
| ------------------------- | ------------------- |
| `zsh-eza.plugin.zsh`      | `sourced-library`   |
| `functions/_zsh_eza_init` | `autoload-function` |
| `tests/helpers.zsh`       | `test-fixture`      |
| `tests/setup.zsh`         | `test-fixture`      |

The directory input includes every file under `functions/`; additions need the same source-profile review. The ZUnit test DSL and vendored tools remain outside this analyzer inventory and retain their existing validation.

The workflow pins the reviewed shared implementation at `af725f0ad9c7b24dd4f4527e582ade2eb8e9ea7b` and analyzer release v1.3.0 at `999cb76cc65ef6af56c0ae65ab0f3622eb527944`. Its artifact records both revisions, resolved inventory, diagnostics, stderr and outcome. Artifact retention is 14 days; lasting qualification evidence belongs on issue #126.

`mode: observe` reports semantic findings without failing the job. Parser failures, malformed configuration and infrastructure failures still fail. The caller grants only `contents: read`, passes no secrets and uses the ordinary `pull_request` event. The pilot is advisory; required-check changes need separate approval after hosted check-name, trigger and fork qualification.

The existing v1.2.0 lint caller and native syntax, compilation and ZUnit workflows remain active. Compare the old invocation and new wrapper at the same analyzer revision when evaluating wrapper behavior, separately from any release-to-release analyzer differences. Roll back this enrollment by reverting the pilot workflow and this guide; the prior validation remains in place.
