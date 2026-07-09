# claude-leanquantum-dpi-mass — the mass-entropy monotone survives coarse-graining: a finite data-processing bound (lean-quantum port)

## Context (blind to any repo; self-contained finite linear algebra, Mathlib only)

Port the data-processing inequality (DPI) core from the lean-quantum package (github
Hayata-Yamasaki-Group/lean-quantum: density operators, channels, partial trace, entropy, DPI) --
reference/provenance, NOT an import (version-pinned). The mass-entropy dictionary reads mass^2 as
the LINEAR entropy of the visible direction register; DPI says a channel (coarse-graining) cannot
DECREASE mixedness of the visible state without a signed coherence exception. Prove the finite,
rational (linear-entropy) version -- avoiding the log entropy that DPI usually uses.

## The model (REAL symmetric 2x2 density operators; rational)

Density operator `rho = !![p, x; x, 1-p]` (real symmetric, PSD, trace 1). Linear entropy
`Slin rho = 1 - tr(rho^2) = 2(p(1-p) - x^2) = 2 det rho` (the mass^2 invariant, rational). A
unital "pinching"/coarse-graining channel `Phi_t rho = !![p, (1-t)x; (1-t)x, 1-p]` (damps
off-diagonal coherence; `t in [0,1]`), the finite avatar of a quantum channel.

## Targets (rational; no log)

1. `channel_is_state`: `Phi_t rho` is a valid density operator (symmetric, PSD, trace 1) for a
   valid `rho` and `t in [0,1]`.
2. `linear_entropy_monotone` (payload -- the DPI core): coarse-graining does not DECREASE linear
   entropy: `Slin (Phi_t rho) >= Slin rho` for `t in [0,1]`, with `Slin (Phi_t rho) - Slin rho =
   2 t(2-t) x^2 >= 0` (closed form, ring). Mass^2 = linear entropy can only grow under
   decoherence -- the finite DPI for the visible direction register. (Reference: lean-quantum's DPI
   for the von Neumann relative entropy; here the LINEAR-entropy avatar, rational.)
3. `signed_closure_exception`: a COHERENT (unitary) pre-rotation can lower the post-channel linear
   entropy vs naive coarse-graining -- exhibit a rational rotation `U` and `t` with
   `Slin(Phi_t (U rho U^T)) < Slin(Phi_t rho)` (closure is not noise; it can reorganize). Explicit
   rational witness.
4. `dpi_verdict`: package -- mass^2 = linear entropy of the visible register is a monotone under
   coarse-graining (DPI), modulo the signed coherent-closure exception; decohering hidden structure
   can only create mass, coherent moves can lower it. The lean-quantum DPI, in the finite
   linear-entropy form the mass dictionary needs. Honest scope: linear (not von Neumann) entropy;
   a finite 2x2 avatar; provenance = lean-quantum DPI.

MANDATORY non-degeneracy: `rho = !![1/2, 1/2; 1/2, 1/2]` (`Slin = 0`, pure/massless), `Phi_1 rho =
!![1/2,0;0,1/2]` (`Slin = 1/2 > 0`, massive) -- coarse-graining created mass; the 3-4-5 rotation
exception witness with `Slin` values as explicit rationals. All in-theorem.

## Constraints (HARD — buildable-proof rule v3)
Kernel-checked only: no sorry/admit/native_decide/new axiom. Mathlib only (lean-quantum is a
REFERENCE, not an import). Footprint exactly [propext, Classical.choice, Quot.sound]; in-file
`#guard_msgs (whitespace := lax) in #print axioms <thm>` on every headline. REAL rational 2x2 (NOT
Complex -- the mass dictionary's linear entropy is real; keep it real for build speed);
ring/norm_num/decide/fin_cases; NO Complex, NO Real.log/sqrt/cos/sin, NO nlinarith deg>=3. Build
under 3 min. Deliver RequestProject/Main.lean (namespace LeanQuantumDPIMass) + ARISTOTLE_SUMMARY.md
WITH the lean-quantum provenance line (package, DPI decl, version gap).
