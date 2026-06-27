# Point-split / flavored-mass gauge-covariance construction plan (Wave 18, C79)

Date: 2026-06-27.
Kind: no-build strategy/audit. Report-only deliverable.

Scope: this is the **flavored / branch-projector** companion to the Wave-17
null-Wilson gauge-covariance job (`C73 →
PhysicsSM/Draft/NullEdgeNullWilsonGaugeCovariance.lean`). Where C73/C70 treat the
*scalar* regulator `W(q) = ∑_a (1 - cos q_a)` as a global branch-lifting
positivity lemma, this plan treats the **flavored-mass / point-split branch
projectors** that carry modified chirality `Γ_f`, the taste/branch index, and the
bridge to a Hermitian spectral-flow (overlap/Ginsparg–Wilson) kernel.

It reuses, and does not duplicate, the already-integrated C61 link-dressing API
(`PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean`), the flavored
chirality model (`PhysicsSM/Draft/NullEdgeFlavoredChirality.lean`), the branch
Krein package (`PhysicsSM/Draft/NullEdgeBranchKreinSignatures.lean`), the
ghost-zero calculus (`PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean`), and
the high-momentum null-branch census
(`PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean`). The companion API
module is the C77 target `PhysicsSM/Draft/NullEdgeFlavoredSpectralFlowAPI.lean`.

> **Honesty banner (binding).** Nothing below claims the link-dressed flavored
> operator is local, ghost-safe, or prediction-grade. The proven content
> targeted here is *kinematic*: momentum-space corner algebra of the projectors,
> exact gauge covariance of dressed finite shift composites, Hermiticity /
> Krein-pairing bookkeeping, and the logical separation of covariance from
> ghost-zero safety and from locality. Section 7 lists every new
> modulus/counterterm and the tetrahedral-symmetry cost.

---

## 0. Geometry and conventions reused from the project

The null-edge kinetic seed lives on the tetrahedral frame of **four primitive
future-null directions** `ℓ_a`, `a ∈ {0,1,2,3}`, with Gram
`G_ab = g(ℓ_a, ℓ_b)`, `G_aa = 0`, `G_ab = 4/3` (`a ≠ b`), inverse Gram
`G^aa = -1/2`, `G^ab = 1/4`, and dual covectors `α^a = ∑_b G^ab ℓ_b^♭`
(`Sources/NullStrand_Lean_Roadmap_Improved.md`, §"corrected target").

The **high-momentum null branches** are the four `{0,π}^4` corners with exactly
three `π` edges; the taste/species label `a` is the position of the unique
non-`π` edge (`TetrahedralHighMomentumNullBranch.count_highMomentumNull = 4`,
`g5 = (+,+,-,-)`). Denote these corners

```text
Q_a := the {0,π}^4 covector with (Q_a)_a = 0 and (Q_a)_b = π for b ≠ a.
```

Per direction `b`, the unit forward null-edge shift is `S_b` (hop by `+ℓ_b`); the
backward shift is `S_b† = S_b⁻¹` (hop by `-ℓ_b`). On plane waves
`e^{i q·x}`, `S_b ↦ e^{i q_b}`, so

```text
cos q_b = ½ (S_b + S_b†),    q_b := q·ℓ_b   (the edge phase along ℓ_b).
```

`S_b` carries `ShiftDir.retarded`, `S_b†` carries `ShiftDir.advanced`
(`NullEdgeGaugeCovariantBranchProjectors.ShiftDir`).

---

## 1. Free-field momentum-space point-split projectors `P_a(q)`

**Definition (corner-selecting trig filter).** For each taste corner `a`,

```text
P_a(q) := ( (1 + cos q_a) / 2 ) · ∏_{b ≠ a} ( (1 - cos q_b) / 2 ).
```

Each factor is the elementary branch filter already named in C61 (`(1 ± cos q)/2`
in position space `½ ± ¼ (S + S†)`); `P_a` is the **point-split** product over
all four directions that isolates one corner.

**Corner-orthonormality (the defining facts, all finite `decide`/`norm_num` on
the `{0,π}` corner set).** Writing `δ` for Kronecker delta:

```text
P_a(Q_c) = δ_{ac}              (P_a is 1 at its own corner, 0 at the others),
P_a(0)   = 0                   (all P_a vanish at the origin / physical mode),
∑_a P_a(Q_c) = 1   for every corner c,
P_a(Q_c) · P_b(Q_c) = δ_{ab} P_a(Q_c)   (orthogonal idempotents on the corner set).
```

Check at `Q_c`: `cos (Q_c)_a = +1` iff `a = c`, else `-1`; substituting gives the
table above. These are the momentum-space images of the branch-projector algebra
already proven *as matrices* in `NullEdgeBranchKreinSignatures` (`Pbranch_idem`,
`Pbranch_orthogonal`, `Pbranch_completeness : ∑_a P_a = P_null`); this plan keeps
both descriptions and asks for an explicit `P_branch_eval` bridge lemma
(Section 6, T1) instead of re-deriving the algebra.

**Flavored mass from the projectors (point-split flavored mass).** With a
taste-sign system `τ : Fin 4 → {±1}` (model input; the C61/`NullEdgeFlavoredChirality`
pattern is `τ = (+,+,-,-)`, aligned with `g5`) and mass scale `m`:

```text
M_flavored(q) := m · ∑_a τ_a P_a(q).
```

This is the **flavored mass operator**: it assigns `m·τ_a` to corner `a`, i.e. a
branch-dependent (signed) mass that distinguishes tastes. The branch-blind naive
mass is the special case `τ_a ≡ 1`, giving `m · ∑_a P_a = m · P_null` on the
corner set. The modified/flavored chirality is `Γ_f = Γ_s · T` with taste
involution `T = diag(τ)` (`NullEdgeFlavoredChirality.GammaF_eq_GammaS_mul_tasteT`);
the relation to `M_flavored` is that `M_flavored` is the off-diagonal flip whose
sign per branch is read by `Γ_f` rather than `Γ_s` (so the flavored index
`tr(Γ_f P_null) ≠ 0` while `tr(Γ_s P_null) = 0`,
`NullEdgeFlavoredChirality.naive_index_zero` / `flavored_index_ne_zero`).

**Hermitian spectral-flow kernel (the overlap bridge).** The object that carries
the branch index is the Hermitian one-parameter family

```text
H(m) := Γ_s · ( D_+ + M_flavored ),
```

(`Γ_s`-Hermitised kinetic seed plus flavored mass). Its spectral flow as `m`
sweeps through `0` counts the would-be zero modes per corner with the taste sign
`τ_a` — the Creutz–Kimura–Misumi / point-split route to a flavored index
(`1011.0761`, `1110.2482`). The overlap operator is the formal
`D_ov = 1 + Γ_s · sign H(m)`; **its locality requires a gap theorem and is not
assumed here** (that is the C78 audit, `null-edge-overlap-locality-gap-audit.md`).

---

## 2. Finite-shift position-space representation

Substituting `cos q_b = ½ (S_b + S_b†)` into each factor:

```text
(1 + cos q_a)/2 = ½ + ¼ (S_a + S_a†),
(1 - cos q_b)/2 = ½ - ¼ (S_b + S_b†)   (b ≠ a).
```

Hence `P_a` is the **finite-range stencil**

```text
P_a = ( ½·1 + ¼ S_a + ¼ S_a† ) · ∏_{b≠a} ( ½·1 - ¼ S_b - ¼ S_b† ).
```

Structural facts the position-space form must record:

* **Finite range / support.** Expanding the product, every term is an ordered
  word in `{1, S_b, S_b†}` using **each direction `b` at most once** (degree ≤ 1
  per direction). The stencil reaches at most one forward or one backward step in
  each of the four null directions, i.e. support inside the elementary null
  cell ∑_b {0, ±ℓ_b}. The number of distinct words is `3·3·3·3 = 81` (3 choices
  per factor: `1`, forward, backward). This is the explicit "point-split"
  insertion set.

* **Term classification by offset.** Each word `w = S_{b1}^{±} … S_{bk}^{±}`
  produces a net lattice offset `Δ(w) = ∑_j (±ℓ_{bj})` and a path
  `path(w) = [ (b1,±), …, (bk,±) ]` (ordered list of primitive null hops).

* **Identity / on-site term.** The `½^4` coefficient on the empty word is the
  length-0 (local) piece; it is the only strictly local term.

* **Single-direction terms.** Words of length 1 (`S_b` or `S_b†`) are single
  primitive-null hops; these are the C61 `cos`-filter atoms.

* **Cross terms.** Words of length ≥ 2 (`S_b S_c`, `S_b S_c† S_d`, …) are
  *composite* hops along a path of distinct primitive null edges. Their net
  offset `Δ(w)` is a sum of two-or-more null vectors and is generically **not**
  itself a primitive null direction (see Section 5).

The flavored mass `M_flavored = m ∑_a τ_a P_a` is therefore a single finite
Hermitian stencil: a local mass term plus point-split (neighbor-connecting)
insertions with branch-weighted coefficients. The "point splitting" is exactly
that the mass connects a site to neighbors rather than acting purely on-site.

---

## 3. Link-dressing the shifts for gauge covariance

A bare shift `S_b` is **not** gauge covariant: under `ψ_v ↦ g_v ψ_v` the value
`ψ_{v+ℓ_b}` does not transform like a field at `v`. The cure is C61's
link-dressing — replace each shift by parallel transport along the edge it
crosses:

```text
S_b      ↦  U_{ℓ_b} S_b              (forward, retarded),
S_b†     ↦  (U_{ℓ_b} S_b)† = S_b† U_{ℓ_b}†   (backward, advanced),
```

so the symmetric atom dresses to the **Hermitian** combination

```text
cos q_b  ⤳  ½ ( U_{ℓ_b} S_b + S_b† U_{ℓ_b}† ),
```

which is manifestly self-adjoint (necessary for `M_flavored` to stay a real mass
term and for `H(m)` to stay Hermitian — see Section 4).

**Composite (cross-term) dressing.** A length-`k` word `S_{b1}…S_{bk}` dresses to
the **path-ordered** transport `U_{ℓ_{b1}} (shift) U_{ℓ_{b2}} (shift) …`, i.e.
the ordered link product `W(path(w))` along the chosen path. The gauge algebra is
exactly the C61 lemmas, reused verbatim:

* `gaugeLink_comp` : composing transports `a→b` and `b→c` cancels the
  intermediate unitary `g_b`, giving the transport of the composed path. This is
  why a connected dressed word stays covariant.
* `dressedHop_gauge` : a field transported to the base point by `W` transforms by
  `g_a` at the base point only.
* `dressedProjector_gauge_covariant` : a finite list of dressed shifts (a
  stencil) transforms by the single base-point factor `g_a`. The point-split
  stencil of Section 2, with each word replaced by its path-ordered transport, is
  exactly an instance of `dressedProjector`, so **the dressed `P_a` and dressed
  `M_flavored` are gauge covariant by `dressedProjector_gauge_covariant`** once
  the stencil is encoded as a `List DressedShift` whose `W` field is the ordered
  link product `W(path(w))`.

**Path-ordering ambiguity (a genuine new choice).** The single-direction atoms
have a canonical dressing (one edge, one link). But a cross-term offset
`Δ = ℓ_b + ℓ_c` can be reached by the path `ℓ_b` then `ℓ_c` **or** `ℓ_c` then
`ℓ_b`; these give different dressed operators `U_{ℓ_b} U_{ℓ_c}` vs
`U_{ℓ_c} U_{ℓ_b}` whenever the connection is non-abelian (they differ by the
plaquette holonomy). Three covariant resolutions, each covariant but
inequivalent off the free-field point:

1. **Fixed ordering** (declare a canonical hop order, e.g. by direction index).
   Covariant, minimal term count, but breaks the `S_4` tetrahedral permutation
   symmetry of the four null directions (Section 7).
2. **Path symmetrization** (average over the orderings reaching the same offset).
   Covariant and restores tetrahedral symmetry, at the cost of extra terms and a
   symmetrization weight modulus.
3. **Shortest-link / chord dressing** (a single transport along the straight
   chord `Δ`, not along the null path). Covariant but **abandons primitive-null
   support** (Section 5) and introduces a non-null link variable.

The free-field limit (`U ≡ 1`) of all three coincides with Section 2, so each is
a legal gauge completion; the choice is a modulus, not forced by covariance.

---

## 4. Forward/backward placement: Krein double vs causal update block

The point-split projectors and the flavored mass are built from **symmetric**
`cos q_b = ½(S_b + S_b†)` atoms — they contain both a retarded (forward `S_b`)
and an advanced (backward `S_b†`) shift in every direction used. Using the C61
`ProjCtx` / `AdmissibleIn` taxonomy:

* **Strictly retarded causal update block (`ProjCtx.causalUpdate`).** Admits
  retarded shifts only. The symmetric `cos` atom fails this:
  `cosFilter_not_causal`. Therefore **`M_flavored` and the point-split `P_a`
  are not admissible in a strictly retarded causal update block** as written.
  A one-sided retarded-only truncation *would* be causally admissible
  (`retFilter_causal`) but is **not Hermitian**, so it cannot serve as a real
  flavored mass and breaks the spectral-flow construction (`H(m)` ceases to be
  self-adjoint, the index/overlap argument collapses). Verdict: do **not**
  one-side the flavored mass to force it into the causal block.

* **Retarded/advanced Krein spectral double (`ProjCtx.kreinDouble`).** Admits
  both orientations provided they are paired (equal retarded/advanced
  multiplicity): `cosFilter_kreinDouble`. The symmetric atom is exactly paired,
  and `M_flavored` is a sum of such atoms, so **the flavored mass and the
  Hermitian spectral-flow kernel `H(m) = Γ_s(D_+ + M_flavored)` live in the
  Krein double `R ⊕ A`**. This is also where the project's Krein metric `kreinJ`
  and branch Krein signatures (`NullEdgeBranchKreinSignatures`) already operate.

* **Gauge-invariant composite / interpolating observable
  (`ProjCtx.compositeObservable`).** Closed base-point loops, contracted into a
  singlet (`loopComposite_gauge_invariant`). The taste-projected *bilinears*
  `ψ̄ Γ_f P_a ψ` and the FMS-style link composites belong here; this is where a
  gauge-invariant flavored order parameter / interpolating field would be built
  (cf. `NullEdgeFMSFiniteComposite`).

**Decision.** Backward/advanced shifts of the flavored mass belong in the **Krein
double**, paired with their forward partners; they must **not** be placed in the
strictly causal update block. The Krein placement is what makes the spectral-flow
/ overlap kernel Hermitian and is consistent with the existing Gate A sign/grading
audit obligations on `Γ_s R`, `Γ_f`, and flavored-mass placement
(`null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`, "Clauses to
preserve").

---

## 5. Which terms preserve primitive-null transport as finite composites

"Primitive null transport" = transport carried only along the primitive null
edges `ℓ_a` (the support discipline emphasised in
`Sources/NullStrand_Lean_Roadmap_Improved.md`: the soldering is carried by the
inverse Gram, but the *support* must stay primitive-null). Classify the stencil
words of Section 2 by whether their dressed form is a finite composite of
primitive-null hops:

| Term class | Net offset `Δ(w)` | Primitive-null status |
| --- | --- | --- |
| identity (`½⁴·1`) | `0` | trivially primitive-null (local) |
| single hop `S_b`, `S_b†` | `±ℓ_b` | **is** a primitive-null link; transport along one edge |
| length-2 word `S_b S_c`, etc. (`b≠c`) | `±ℓ_b ± ℓ_c` | **finite composite** of two primitive-null hops; the *offset* is generically not null (`g(ℓ_b+ℓ_c) = 2G_bc = 8/3 ≠ 0`), but the *transport path* is two primitive-null links |
| length-3, length-4 words | `∑ ±ℓ` | finite composite of 3–4 primitive-null hops; offset non-null |

**Conclusion.** With the path-ordered dressing of Section 3 (option 1 or 2),
**every term of the point-split `P_a` and of `M_flavored` is realizable as a
finite ordered composite of primitive-null link transports** — no off-axis
(non-`ℓ_a`) link is ever introduced. This is the key positive result: the
flavored mass *preserves primitive-null transport as finite composites*. What is
**not** preserved is the stronger property "every term is a single primitive-null
*link*": the cross terms (length ≥ 2) have non-null net offsets and are only
primitive-null at the level of the *path*, not the *chord*. The chord dressing
(Section 3, option 3) is the one resolution that **breaks** primitive-null
support, by introducing a single non-null link; it should be flagged and avoided
unless a separate theorem forces it.

So the precise primitive-null ledger is:

```text
preserve primitive-null transport as finite composites:
  identity term, all single-hop terms, all cross terms under path-ordered
  (or symmetrized) primitive-null dressing.
break primitive-null support:
  chord/shortest-link dressing of cross terms (introduces a non-null link).
```

---

## 6. Proposed Lean theorem package for gauge-covariant branch projectors

Target module: **`PhysicsSM/Draft/NullEdgePointSplitFlavoredMass.lean`**
(new draft), importing `NullEdgeGaugeCovariantBranchProjectors` (C61),
`NullEdgeFlavoredChirality`, `NullEdgeBranchKreinSignatures`,
`NullEdgeGateCGhostZeroSafety`, and the C77 API
`NullEdgeFlavoredSpectralFlowAPI` once it lands. All declarations in the `Draft`
namespace. The module is **kinematic**: it proves corner algebra, covariance,
Hermiticity, Krein-pairing, and the primitive-null classification, and it carries
the analytic obligations as hypotheses, not facts.

Proposed declarations (statements; proofs left to the subagent):

```text
-- §1 momentum-space corner algebra
def pointSplitMom (a : Fin 4) (q : Fin 4 → ℝ) : ℝ
    := ((1 + Real.cos (q a))/2) * ∏ b ∈ Finset.univ.erase a, (1 - Real.cos (q b))/2
def cornerQ (a : Fin 4) : Fin 4 → ℝ                      -- Q_a, the 3-π corner
theorem pointSplitMom_corner   : pointSplitMom a (cornerQ c) = if a = c then 1 else 0
theorem pointSplitMom_origin   : pointSplitMom a (fun _ => 0) = 0
theorem pointSplitMom_complete : (∑ a, pointSplitMom a (cornerQ c)) = 1
theorem pointSplitMom_orthoIdem :
    pointSplitMom a (cornerQ c) * pointSplitMom b (cornerQ c)
      = if a = b then pointSplitMom a (cornerQ c) else 0

-- bridge to the existing matrix branch projectors (no re-derivation of algebra)
theorem pointSplit_eq_Pbranch_on_corners :  -- ties pointSplitMom to NullEdgeBranchKreinSignatures.Pbranch

-- §2 position-space finite stencil
def shiftWord  : List (Fin 4 × ShiftDir)                 -- a point-split word
def pointSplitStencil (a : Fin 4) : List (DressedShift n V)   -- 81-term stencil, dressed via path links
def flavoredMassStencil (m : ℝ) (τ : Fin 4 → ℝ) : List (DressedShift n V)
theorem flavoredMassStencil_freefield_eq_mom : -- free-field (U≡1) stencil reproduces m ∑ τ_a P_a(q)

-- §3 gauge covariance (reuse C61)
theorem pointSplitStencil_gauge_covariant (hg : ∀ v, star (g v) * g v = 1) :
    dressedProjectorGauged g a (pointSplitStencil a) ψ
      = g a *ᵥ dressedProjector (pointSplitStencil a) ψ          -- corollary of dressedProjector_gauge_covariant
theorem flavoredMass_dressed_hermitian :                          -- symmetric dressing ⇒ self-adjoint
    (flavoredMassMatrix m τ U)ᴴ = flavoredMassMatrix m τ U

-- §4 placement
theorem flavoredMass_not_causal     : ¬ AdmissibleIn ProjCtx.causalUpdate a (flavoredMassStencil m τ)
theorem flavoredMass_kreinDouble    :   AdmissibleIn ProjCtx.kreinDouble  a (flavoredMassStencil m τ)
-- Hermitian spectral-flow kernel lives in the Krein double:
def specFlowKernel (m : ℝ) : RMat := GammaS * (Dplus + flavoredMassMatrix m τ U)
theorem specFlowKernel_hermitian : (specFlowKernel m)ᴴ = specFlowKernel m

-- §5 primitive-null classification
def PreservesPrimitiveNull (sh : DressedShift n V) : Prop  -- path is a composite of ℓ_a hops only
theorem pointSplitStencil_primitiveNull :
    ∀ sh ∈ pointSplitStencil a, PreservesPrimitiveNull sh           -- path-ordered dressing
theorem chordDressing_breaks_primitiveNull :
    ∃ sh, ¬ PreservesPrimitiveNull sh                               -- the option-3 resolution

-- §6 separation guardrails (reuse C61 / GhostZeroSafe)
structure DressedFlavoredMass extends DressedBranchProjector n V   -- bundles the zero spectrum
theorem flavored_gaugeCovariant_not_ghostSafe :
    ∃ P : DressedFlavoredMass 1 Unit, P.GaugeCovariant ∧ ¬ GhostZeroSafe P.zeros
theorem flavored_covariance_not_locality :                          -- covariance ⇏ overlap locality
    GaugeCovariant P ∧ ¬ (OverlapGapHypothesis P → OverlapLocal P)   -- stated as: locality needs the gap hyp
```

Analytic / physical inputs that must remain **hypotheses or `sorry`-free
`Prop`-carrying structures**, never asserted as facts:

* `OverlapGapHypothesis` — a spectral gap of `H(m)` away from `m` (the C78
  obligation); without it `sign H(m)` and locality of `D_ov` are not available.
* `PostGaugeGhostSafe` — the C47/C48 post-gauge-coupling residue/ghost contract.
* `TasteSignForced` — that the physical sign pattern `τ` is the one forced on the
  full operator (the open blocker recorded in `NullEdgeFlavoredChirality`).

**Release linkage.** The package should prove that
`FlavoredIndexReady` (C77) ⇒ the chirality clause of
`NullEdgeProjectedGateCRelease.ProjectedGateCRelease`, abstractly, exactly as the
C77 task requests, so this module supplies the gauge-covariant + Krein-placed +
primitive-null-classified projector data that the projected Gate C release
predicate consumes — **without claiming the release fires.**

---

## 7. Scope guardrails: new moduli/counterterms and symmetry cost

**New moduli (classify each as fixed / constrained / tunable / open).**

| Quantity | Role | Status |
| --- | --- | --- |
| `m` (flavored mass scale) | overall scale of `M_flavored` | tunable (regulator scale, like Wilson `r`) |
| `τ : Fin 4 → {±1}` (taste signs) | branch sign pattern, sets `Γ_f` | constrained by the index requirement (`flavored_index_ne_zero`), exact pattern **open** (`TasteSignForced`) |
| relative factor weights (the `½`, `¼` in `(1±cos)/2`) | corner-orthonormality | fixed by the corner-selection conditions of Section 1 |
| path-ordering / symmetrization choice (Section 3) | dressing of cross terms | open (covariant either way; affects non-abelian content) |
| dressing scheme (path-ordered vs chord) | primitive-null support | constrained: path-ordered preserves primitive-null, chord breaks it |

**New counterterms that must be tracked** (not discharged here):

* **Additive mass renormalization** — the point-split insertions shift the
  effective on-site mass; an additive counterterm to retune the physical mass and
  the critical surface (`m_crit`) is generically required.
* **Additive constant / vacuum subtraction** in the spectral-flow kernel to fix
  the zero of `m`-flow.
* **Improvement / clover-type term** if path-symmetrization is used to restore
  tetrahedral symmetry — this is itself a new covariant operator with its own
  coefficient.

**Tetrahedral-symmetry status.** The construction **breaks the `S_4` tetrahedral
permutation symmetry** of the four primitive null directions in two places, and
this must be stated plainly:

1. *Intrinsically, by design.* A flavored mass must distinguish tastes, so the
   sign pattern `τ = (+,+,-,-)` selects an ordered pairing of the four corners
   and is not invariant under all of `S_4` (it is invariant only under the
   subgroup preserving the pairing). Branch-blind `τ ≡ 1` keeps `S_4` but then
   carries no flavored index — i.e. tetrahedral symmetry and a nonzero flavored
   index are in tension. This is expected and is the whole point of the flavored
   mass, but it is a genuine symmetry reduction.
2. *In the dressing.* Fixed path-ordering (Section 3, option 1) further breaks
   `S_4`; path-symmetrization (option 2) restores it at the cost of the extra
   improvement modulus above.

**What is explicitly NOT claimed.**

* Not local: the dressed flavored operator is finite-range at tree level, but the
  *overlap* `D_ov = 1 + Γ_s sign H(m)` is **not** asserted local; locality needs
  `OverlapGapHypothesis` (C78), absent here.
* Not ghost-safe: `flavored_gaugeCovariant_not_ghostSafe` shows covariance does
  not entail ghost-zero safety; the Golterman–Shamir / propagator-zero ghost
  audit (`8NRUZ46K`, `2505.20436`) remains an independent release predicate.
* Not prediction-grade: no continuum limit, no dispersion, no species/doubler
  census beyond the existing four-corner finite model is claimed.

---

## 8. One-line summary

The free-field point-split branch projectors `P_a(q) = (1+cos q_a)/2 · ∏_{b≠a}
(1-cos q_b)/2` become an 81-term finite null-shift stencil; link-dressing each
shift by primitive-null parallel transport makes the flavored mass
`M_flavored = m ∑_a τ_a P_a` and the Hermitian spectral-flow kernel
`H(m) = Γ_s(D_+ + M_flavored)` **exactly gauge covariant** (by the C61 lemmas),
**Krein-double placed** (the advanced shifts pair with retarded ones; not
causal-update admissible), and **primitive-null-preserving as finite composites**
(path-ordered dressing only) — while gauge covariance still says **nothing** about
ghost-zero safety or overlap locality, and the taste sign pattern, path-ordering,
and additive counterterms remain explicit open moduli that reduce tetrahedral
symmetry.
