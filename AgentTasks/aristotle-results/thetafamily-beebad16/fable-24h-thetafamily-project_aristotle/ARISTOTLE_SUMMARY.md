# Summary of changes for run 1b54a8a0-21e4-4aea-9112-2ee15a3f2c9e
Delivered a kernel-only Lean file proving the θ-family involution-protection ladder, plus a memo, with a clean full build and no `sorry`/`native_decide`/`axiom`.

**New file:** `PhysicsSM/Draft/NullEdge/ThetaFamilyProtection.lean` (namespace `PhysicsSM.Draft.NullEdge.ThetaFamilyProtection`), importing Mathlib and the three context modules. The split-step coin is parametrized by a real angle θ: `Wth θ b = shiftR · coinR θ b · shiftR`, the context `walkQ (cos θ) (sitewise signed sin θ)` construction over ℝ, with `Wth_eq_Wexp` pinning it to one explicit 8×8 matrix (the required closed-form bridge; the context `walkQ` is ℚ-typed so a literal `walkQ (cos θ) …` equation is ill-typed).

Everything is quantified over **all** θ : ℝ and each identity reduces to `Real.sin_sq_add_cos_sq` (and `signB x · signB x = 1`):
- **T1** `block_involution_family` (+4 explicit block corollaries): the walk is symmetric and `W·W = 1`.
- **T2** `chart13_involution_family` (+4 protected-singleton corollaries): the `{1,3}` compression `M13 = Bfixᵀ W Bfix` is symmetric, involutive, traceless, and intertwines the walk.
- **T3** `chart02_involution_family` (+4 blind-singleton corollaries): the same four facts for the `{0,2}` chart (`Bfix0`).
- **T4** `modes_persist` (headline): for every θ and every two-wall field, the complete walk over ℂ has a nonzero +1 and a nonzero −1 eigenvector — obtained by an ℝ→ℂ transport (`toCR`) feeding the landed `InvolutiveCompression` engine, with a `decide`-based chart dispatch (`two_wall_chart`).
- **T5** negative controls: `(M13 − M13ᵀ)(0,1) = −2·sin θ` for the blind singleton `[+,+,+,-]`, the zero-wall `[+,+,+,+]`, and the four-wall `[+,-,+,-]` fields in the wrong chart `{1,3}`, hence self-adjointness fails there for every θ with sin θ ≠ 0.
- **T6** massless boundary: at sin θ = 0 the control entry vanishes, scoping the failure to the massive family sin θ ≠ 0.

Kill condition: no extra θ-term survives on any protected/block identity (the only surviving θ-terms are the intended −2·sin θ control entries), so the family claim holds symbolically. `#print axioms` on the headline theorems shows only `propext`, `Classical.choice`, `Quot.sound`.

**Memo:** `THETA_FAMILY_PROTECTION_MEMO.md` lists the exact statements and setup.

**Build fix (no context edits):** the delivered project did not build — the two context files import `PhysicsSM.Draft.NullEdge.*` module paths that did not exist (files live under `context/`). Fixed by adding three one-line shim modules under `PhysicsSM/Draft/NullEdge/` (each re-importing the corresponding `context.*` module) and a matching `lean_lib` entry in `lakefile.toml`; the context modules' contents are untouched.

The full project builds successfully with no warnings, and all changes are committed and pushed.
