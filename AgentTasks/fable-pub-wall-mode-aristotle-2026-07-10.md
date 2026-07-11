# Aristotle proof task: exact localized modes at Pluecker sign walls (Paper C pillar 3 witness)

Overnight publication run 2026-07-11, Fable lane F2. Focused standalone
package (Mathlib-only); ALL matrices and vectors are explicit Q(i) literals
generated and symbolically verified by the scratchpad oracle
(wall_parity_oracle.py, wall_mode_exact.py, wall_mode_inverse.py) before
submission - every proof is literal arithmetic, no search.

Oracle findings encoded: the 8-site split-step walk with 3-4-5 coins and a
sign wall (field +m sites 0-3, -m sites 4-7) has exact +1 and -1
eigenvectors with explicit rational amplitudes localized at the walls
(site probability 256/5 at the 3|4 wall vs 1 antipodally; geometric decay
ratio exactly 1/2 per site matching (1-sin)/cos); the constant-field
control has no such modes (explicit two-sided inverse certificates for
constWalk -+ 1, max numerator 257). Naive per-site sigma_x gradings FAIL
the chiral relation for this walk, and det = +1 identically in the periodic
family - so this witness route does NOT go through the det engine; the
general protection statement remains with ecbe0d8b + the sectored-index
design (b407e2d5).

Targets: T1/T2 exact modes, T3 localization values, T4 control
certificates, T4' no-pinned-modes corollary, T5 spinor derivation of the
wall profile.

Manuscript consequence: closes the "explicit localized mode + zero-wall
negative control" half of the Paper C gate with fully derived data
(pillar 1 supplies the winding layer; the wall here is the collinearity
crossing). Remaining C gate: general index/protection bridge + stability
class.

```yaml
aristotle:
  project_id: 79d2a55a-71b9-41fa-8bf9-1065f07bc0ca
  target_file: WallModeWitness/Main.lean
  expected_module: WallModeWitness.Main
  submission_project: AgentTasks/aristotle-submit/fable-pub-wall-mode-20260710-project
  output_dir: AgentTasks/aristotle-output/79d2a55a-71b9-41fa-8bf9-1065f07bc0ca
  status: submitted
  run: overnight-publication-run-2026-07-11
  owner: Fable
```
