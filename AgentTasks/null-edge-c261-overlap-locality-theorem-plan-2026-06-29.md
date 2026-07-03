# Summary of changes for run 0a9118f4-b802-4345-a1c8-b47903bdaf96
Completed Gate C1 task C261 — the overlap locality theorem plan — by building a fully verified, finite-dimensional Lean development of the overlap / Ginsparg–Wilson sign-kernel locality program.

The referenced prompt file was not present in the project, so I grounded the task from its title and the repository's non-ultralocal release plan (Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md), which fixes the overlap-lane posture: "treat exponential locality as a sufficient theorem under gap/smoothness hypotheses."

New Lean module: PhysicsSM/Draft/NullEdge/GateC1/OverlapLocality.lean. Over a finite set of sites with an abstract integer pseudo-distance, it defines the finite-range predicate `IsRange` and the exponential-locality predicate `ExpLocal`, and proves the full theorem stack:
- Finite-range algebra: `isRange_mono`, `isRange_zero`, `isRange_one`, `isRange_add`, `isRange_smul`, `isRange_neg`, `isRange_sum`, the key `isRange_mul` (range adds under matrix products, via the triangle inequality), `isRange_pow`, and `isRange_aeval` (a degree-≤n polynomial in a range-r matrix is range-(n·r) — polynomial functional calculus is finite-range).
- `overlap_surrogate_finite_range`: the overlap operator `Dov gamma5 (p(H)) = 1 + gamma5·p(H)` built from a degree-≤n polynomial is range-(n·r).
- `expLocal_of_finite_range`: packaging finite range into the exponential-locality vocabulary.
- `sign_kernel_exp_locality_target` (the C261 main theorem): from a finite-range H and exponentially good, linearly-growing-degree polynomial sign approximants, the sign kernel `eps` is exponentially local — there exist C>0 and 0≤q<1 with ‖eps i j‖ ≤ C·q^dist(i,j). The proof uses `isRange_aeval` to force the degree-n approximant to vanish beyond range n·r and optimizes the truncation level n ≈ dist/r to convert the exponential approximation bound into geometric decay.

Every declaration is proved with no `s o r r y`; `#print assumptions` confirms only the standard assumptions (propext, Classical.choice, Quot.sound). The module compiles cleanly with no warnings.

I also added a companion plan document, Sources/Null_Edge_Gate_C1_C261_Overlap_Locality_Theorem_Plan.md, describing the theorem stack, the proof mechanism, and how it fits the broader release plan (it complements the existing algebraic Ginsparg–Wilson identity in OverlapGinspargWilson.lean).

Note: the project's default build target was already broken before this work — PhysicsSM/Draft/NullEdge/GateC1/TetraQSquareExact.lean imports a module `TetrahedralGlobalGap` that does not exist in the repository (present in the initial commit). That is unrelated to this task and was left untouched; the new OverlapLocality module does not depend on it and builds successfully on its own.
