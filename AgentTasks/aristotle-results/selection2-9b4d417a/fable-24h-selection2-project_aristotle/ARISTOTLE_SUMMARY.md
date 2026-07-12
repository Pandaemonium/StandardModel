# Summary of changes for run 2fdefe5d-e537-4f0d-8f68-dd489c6b1d05
Replaced the placeholder in `Selection2Repairs.lean` with the four genuine audit-repair theorems (F5/F7/F9/F10). All definitions (`famH`, `Dphase`, `G1`, `pairFst`, `pairSnd`, `minorLift`, `G2`, plus the Gaussian-integer twin infrastructure `G1g`/`minorLiftg`/`G2g`/`phi` and the `toComplex` bridge lemmas) were copied verbatim from the context modules and left unaltered.

Targets proved (file builds clean, no `sorry`/`native_decide`; each verified to use only `propext`, `Classical.choice`, `Quot.sound`):

- T1 `scalar_gauge_collapse` (F5): under the SCALAR gauge `Dscalar u = diag(u,u)`, the selection constraints force `famH C A B z = 0` for every `z`. Conjugation by `diag(u,u)` is trivial for unimodular `u`, so equivariance gives `H(uz)=H(z)`; instantiating at `u=I,-1` together with vanishing kills `C`, `A`, `B`. (The full three-constraint set is stated for faithfulness; the Hermiticity hypothesis turned out unused, noted in the docstring.)

- T2 `equivariance_violating_control` (F7): the explicit family `Hviol z = (z + conj z) • !![0,1;1,0]` is Hermitian for all `z` and vanishes at `z=0`, yet violates chiral equivariance — witnessed by `u = I`, `z = 1`, where the left side is `0` but the conjugated right side is nonzero.

- T3 `no_odd_generator_on_full_samesite_block` (F9): extended the `{0,13}` corner to the full same-site block `{0,13,22,27}` (pairs (0,1),(2,3),(4,5),(6,7)); any Hermitian `H` supported there with `G2 * H = -(H * G2)` vanishes. Uses the Gaussian-integer twin `decide` + `toComplex` transport pattern; `G2` is `-1` on all four same-site indices.

- T4 `G2_census_exact` (F10): the exact census — `G2` has exactly four `(-1)`-fixed basis states, precisely at `{0,13,22,27}`; every state maps to `±` its component-flip partner via the explicit involution `partner` (flip both components of the two sites), that partner is the unique target, and `partner p = p` exactly on the four same-site indices. The oracle-level partner table was confirmed correct (proved by `decide` on the integer twin, then transported to ℂ).

Work committed and pushed to `main`.
