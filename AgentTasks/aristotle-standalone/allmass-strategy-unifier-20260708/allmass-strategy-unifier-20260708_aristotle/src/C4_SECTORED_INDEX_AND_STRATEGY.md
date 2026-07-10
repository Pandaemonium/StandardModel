# C4 resolved + strategic direction (Fable call-02, 2026-07-08)

Full log: `AgentTasks/model-calls/claude/2026-07-08-001918-fable-call-02.md`.

## Part A: the balanced-inertia capstone route (hand to Aristotle)

From `hsym : (-B).charpoly = B.charpoly` (LANDED as `anticonj_charpoly_eq`)
and `hB : B.IsHermitian`, the count `n_+ = n_-` follows via:
1. ONE custom lemma `charpoly_neg`: `(-B).charpoly = C((-1)^card n) *
   (B.charpoly.comp (-X))` (~10 lines; entrywise charmatrix map +
   RingHom.map_det + det_smul).
2. `Polynomial.roots_comp_neg_X` + `Polynomial.roots_C_mul` =>
   `(-B).charpoly.roots = B.charpoly.roots.map (-.)`; rewrite by hsym.
3. `Matrix.IsHermitian.roots_charpoly_eq_eigenvalues` both sides; push
   Neg through RCLike.ofReal, cancel via Multiset.map_injective.
4. Feed Codex's `card_pos_eq_card_neg_of_multiset_map_neg_eq`.
Mathlib-only; Aristotle package. This CLOSES the S1-CC inertia capstone.

## Part B: C4 is a reflection-sectored index, NOT a global winding number

**Measured (Fable, machine precision, V=4,6,8):** for the half-winding
decoration the GLOBAL index vanishes (`tr Gamma = tr(Gamma W) = 0`,
nu_0 = nu_pi = 0) yet `mult(+1) = mult(-1) = 2`. So no global invariant
forces the pinning. My `ChiralZeroModeParity.lean` docstring and the
manuscript S8 attributed it to an Asboth-Obuse global winding - CORRECTED
this run.

**Correct mechanism (equivariant sectored index):** `W` commutes with a
reflection `R` = leg-reversal ∘ orientation-swap (`R^2 = 1`, `[R,Gamma]=0`).
`C := Gamma W` is an involution (`C^2 = W^dag W = 1`), so `W = Gamma·C` is a
product of two `R`-commuting involutions. Per sector `P_± = (1±R)/2`:

  nu_0(±) = (1/2) tr((Gamma + Gamma W) P_±),
  nu_pi(±) = (1/2) tr((Gamma - Gamma W) P_±)   (integers).

**Theorem (M-target, spectral-theorem-free):** in each R-sector V_chi,
`dim(ker(W-1) ∩ V_chi) >= |nu_0(chi)|`, `dim(ker(W+1) ∩ V_chi) >=
|nu_pi(chi)|`. Proof: Gamma, C involutions => V_chi splits into ±1
eigenspaces; Gamma v = C v = v (or both -v) => W v = v; the two intersections
sum directly; `Submodule.finrank_sup_add_finrank_inf_eq` gives
`dim >= |p + p' - d| = |nu|`. Mathlib: idempotents `(1±Gamma)/2`,
`LinearMap.IsProj.trace` (trace of proj = finrank). No Hermiticity of Gamma
needed - the repo `ChiralInvolution` + `W^dag W = 1` + commuting R suffice.

**Half-winding computation:** `Gamma = 1_V ⊗ sigma_x`, `R` = leg-reflection
∘ orientation-swap. `tr(Gamma W P_±) = 0` => nu_0(±) = nu_pi(±) = ±(1/4)
tr(Gamma R), and `Gamma R` = bare leg-reflection => `tr(Gamma R) = 2·#fixed
legs = 4` (even V: legs 0 and V/2). So `nu = ±1` per sector => mult(±1) >= 2,
matching (2,2) at every |t|. The invariant is a LEFSCHETZ number (fixed-point
count of R) - it does NOT involve W, explaining the |t|-independence.

**Controls (Fable ran):** chirality-alone (R broken) => pinning destroyed
(mult (0,0)); palindromic-t (R preserved) => (2,2) intact. Passed both
falsifier directions.

**Rational fixture (decide-style M-target):** V=4, t=3/5, f=4/5, alternating
phases - W is a REAL matrix. Verify sector indices (±1,±1) and mult(±1)=2
by exact arithmetic. Kill conditions K-C4a/b/c in the log.

## Part C: the three highest-leverage next targets (Fable ranking)

1. **Total-operator positivity on the doublet-free complement** (the S1-CC
   survivor) - the PROGRAM-WIDE bottleneck (spectral embargo lifts when it
   resolves; precondition for S5; gives Banks-Casher its physical reading).
   First theorem (house-style, 3-line proof):

   ```lean
   theorem aperture_dominance_pos (A C : Matrix n n ℂ) (P : Submodule ℂ (n → ℂ))
       (c κ : ℝ) (hκc : κ < c)
       (hA : ∀ v ∈ P, c * ‖v‖ ^ 2 ≤ (star v ⬝ᵥ A.mulVec v).re)
       (hC : ∀ v ∈ P, |(star v ⬝ᵥ C.mulVec v).re| ≤ κ * ‖v‖ ^ 2) :
       ∀ v ∈ P, v ≠ 0 → 0 < (star v ⬝ᵥ (A + C).mulVec v).re
   ```
   Rung 2: κ ≤ ‖bivector‖·‖K‖. Rung 3: compute c, κ on the 6×6 S1-CC witness
   (rational) - first kernel-checked total-operator positivity on a physical
   sector. The dominance constant IS the aperture gap = the trusted det P
   disagreement invariant (circle closes).
2. **S6 mass-budget on a genuine color-singlet** (vs tonight's single-edge
   witness) - unblocked now (budget needs no positivity), exhibits the
   balanced-closure sign structure (hyperfine pi/rho-analog). Claim upgrade
   + prediction in one.
3. **S5 first-meson witness** (after #1) - OS/transfer gap turns a singlet
   two-point fn into "hadron correlator decays at the gap rate", the first
   honest finite hadron-mass statement.
- **DEMOTE KP** (forest injection) to a standing Aristotle bounty, not a
  lane: 5 failed attempts, marginal honest-mass gain small.
- (v) The deeper unifier: equivariant index theory on decorated complexes
  (McKean-Singer, C4 sectored pinning, S1-CC constraint grading are all
  instances) - a program note.

## Source-review nits (Fable, applied/handoff)
- `ChiralZeroModeParity.lean` docstring winding misattribution: CORRECTED
  this run. `ChiralInvolution` omits `Gamma^H = Gamma` (harmless; note it).
- `S1CCBalancedInertia.lean`: `anticonj_trace_zero` docstring header
  "Even-power form" mislabels the k=0 ODD case - handoff to Codex (its file).
