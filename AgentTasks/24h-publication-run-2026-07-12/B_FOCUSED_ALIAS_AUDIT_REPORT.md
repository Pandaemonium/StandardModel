# B_FOCUSED_ALIAS_AUDIT_REPORT

Hostile, review-only semantic audit of the failed `3+1` successor routes.

**Scope (verbatim, as instructed).** Only the six named modules and lines
1640–1740 of
`Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
were read. No files were edited and no build was run.

- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeProjectorWalk.lean`
- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylTangent.lean`
- `PhysicsSM/Draft/NullEdge/StationaryAmplitudeWeylAlias.lean`
- `PhysicsSM/Draft/NullEdge/PairedDeterminantReality.lean`
- `PhysicsSM/Draft/NullEdge/ReciprocalCoinFamily.lean`
- `PhysicsSM/Draft/NullEdge/CoupledReciprocalSliceNoGo.lean`

**Scope limitation (declared, not a defect).** Two of the six modules import
material that was *not* in the audit set and therefore was not read:
`ReciprocalCoinFamily` imports `ReciprocalConditionalShiftRegulator`
(`reciprocalRegulator`, `neg_one_has_no_zero_or_pi_crossing`, `conditionalShift`,
`IsUnitary2`, `isUnitary2_mul`, `conditionalShift_unitary`, `coin`, `coinInv`),
and both stationary-amplitude successor modules build on
`StationaryAmplitudeProjectorWalk` (which *is* in scope). Every claim that rests
on the unread regulator file is flagged below as **out-of-scope dependency**.
Axiom hygiene is asserted only from the in-source `#print axioms` / `#guard_msgs`
pins, which list `[propext, Classical.choice, Quot.sound]` in every module; I did
not re-run the kernel.

**Headline verdict.** The six modules are, as *pieces of mathematics*, sound and
faithful: their theorem statements match their proofs, the conventions are
internally consistent, and the manuscript's negative/positive labels are, with
the specific narrowings listed below, honestly bounded. The two "no-go"
statements are correctly scoped as **architecture-level** (indeed one of them is
even narrower: **slice-level**), not universal. The single most important
missing piece is a **non-triviality / non-constancy negative control** on the
stationary-amplitude symbol, without which the flagship alias theorem
(`exists_distinct_identity_alias`) is only *hollow-proof-resistant by inference*,
not by kernel. Details follow.

---

## 1. The central audit boundary: architecture-level vs universal no-go

Both negative results are correctly fenced, in *source* and in *prose*:

| Result | What is actually proved | Correct scope | Where a reader could over-read it |
|---|---|---|---|
| `CoupledReciprocalSliceNoGo.exists_additional_zero_crossing` / `exists_additional_pi_crossing` | On the **single slice** `q_x=π, q_y=0`, the displayed chirality-coupled reciprocal word has a zero- and a π-quasienergy crossing at some `q_z≠0`. | **architecture-level, and in fact slice-level**, for the *one displayed* coupled construction. | as "reciprocal walks cannot be alias-free" (universal) — explicitly denied by the module docstring ("does not rule out enlarged-register or otherwise modified reciprocal constructions") and by the manuscript ("`\NoGo{}` `\Kernel{}` for the displayed direct construction, not a universal reciprocal no-go"). |
| `StationaryAmplitudeWeylAlias.exists_distinct_identity_alias` | The *specific* rational three-axis symbol has a second identity crossing at `(-1,1,-1)`. | **architecture-level**: this construction is not unique-cone. | as "the stationary-amplitude route cannot give a unique Weyl cone" — denied by the module prose and manuscript ("the *explicit* stationary-amplitude construction is not unique-cone"). |

Places where an architecture-level statement could be *mistaken* for a universal
one (check 5), each already guarded:

1. **Coupled slice no-go** — narrowest of all: it is proved *only on the slice*
   `q_x=π, q_y=0`, not even over the full torus of that architecture. The
   existentials assert *some* `q_z≠0`; they do not, and do not claim to, census
   the whole slice. Guarded by the docstring and by the manuscript's "on that
   slice" qualifier.
2. **Stationary-amplitude alias** — architecture-specific; guarded.
3. **Paired-determinant reality gate** (`PairedDeterminantReality`) — this is a
   *reality* lemma, not a root-existence theorem. A reader could over-read it as
   "the reciprocal sign oracle is proved". The manuscript explicitly downgrades
   it ("remains conditional until the live `U_±(q)` blocks … are composed in one
   theorem"). No overclaim. See §4.
4. **Coin-family corner classification** (`ReciprocalCoinFamily`) — a *two-band
   primitive* classification at the corner `z=-1`, explicitly "not a
   four-component embedding or an all-torus root theorem" (module docstring).
   Guarded.

Bottom line on the boundary: **no module crosses architecture→universal**, and
the prose in the cited range keeps the fence. The one residual risk is not a
scope inflation but a *vacuity* risk on the alias route (§2, §7).

---

## 2. Theorem-by-theorem semantic verdicts

Legend: **SOUND** = statement is the intended physics and proof matches;
**SOUND / narrow** = correct but weaker than the surrounding prose suggests;
**GAP** = a needed control is absent (not a false theorem).

### 2.1 `StationaryAmplitudeProjectorWalk.lean`

| Theorem | Verdict | Notes |
|---|---|---|
| `stationaryWalk_expansion` | SOUND | Exact range-one Laurent form `zΓ₊+Γ₀+z⁻¹Γ₋`. The added `z≠0` hypothesis is genuinely necessary (onsite band carries `z·z⁻¹`); documented honestly. Matches manuscript display. |
| `forwardPhase_mul`, `backwardPhase_mul` | SOUND | Correct phase-composition on `range P` / `ker P`. |
| `forwardPhase_conjTranspose`, `backwardPhase_conjTranspose` | SOUND | The *corrected* same-family adjoint law under `conj z = z⁻¹`. The docstrings correctly document that the originally displayed `(fwd)ᴴ = bwd` was false; the given counterexample (`P=|0⟩⟨0|`, `z=i`) is correct. This is a real faithfulness fix, not hollow telescoping. |
| `forwardPhase_unitary`, `backwardPhase_unitary`, `isUnitary_mul`, `stationaryWalk_unitary` | SOUND | Exact on-circle unitarity **without** assuming `[P,Q]=0`. Hypotheses (`z≠0`, `IsStarProjection`, `conj z=z⁻¹`) are all satisfiable and load-bearing. |
| `projA_isStarProjection`, `projB_isStarProjection` | SOUND | `projA=diag(1,0)`, `projB` the 3-4-5 rank-one projector; both genuine `IsStarProjection`. |
| `projectors_do_not_commute` | SOUND | Genuine noncommutation witness. |
| `gammaZero_nonzero` | SOUND | `Γ₀=[[16/25,-12/25],[12/25,16/25]]≠0`, exactly the manuscript's displayed `Γ₀`. Genuine onsite amplitude, not a rewritten pure shift. |
| `explicit_stationary_walk_unitary` | SOUND | Non-vacuous: at `z=I` (which does satisfy `conj I = I⁻¹`), exact unitary **and** nonzero onsite. |

No vacuity, no contradictory hypotheses, no false shape. The `z≠0` and
adjoint-law corrections are exactly the ones the manuscript admits were
"enforced during formalization after the originally proposed formulas failed".

### 2.2 `StationaryAmplitudeWeylTangent.lean`

| Theorem | Verdict | Notes |
|---|---|---|
| `gammaMoment_eq` | SOUND | `Γ₊−Γ₋ = P+Q−1`. Tied to the real Laurent coefficients via `stationaryWalk_expansion`. |
| `P{x,y,z}/Q{x,y,z}_isStarProjection` (6) | SOUND | All six are genuine `IsStarProjection`. |
| `{x,y,z}_projectors_do_not_commute` (3) | SOUND | Each axis pair genuinely noncommuting. |
| `x_gammaMoment`, `y_gammaMoment`, `z_gammaMoment` | SOUND | First Laurent moments exactly `(3/5)σ_x`, `(3/5)σ_y`, `(3/5)σ_z`. This *is* isotropy of the **per-axis** velocity (equal magnitude 3/5 along all three Pauli directions). |
| `axis_gammaZero_nonzero` | SOUND | Every axis keeps a genuine onsite amplitude. |
| `weylStep_unitary` | SOUND | Exact all-torus unitarity of the ordered product, no commuting assumption. |
| `weylStep_one` | SOUND | Identity at the origin `(1,1,1)`. |
| `exists_stationary_amplitude_isotropic_weyl_fixture` | **SOUND / narrow** | Non-vacuous capstone bundling the above. **Narrowing:** "isotropic Weyl first jet" is proved *per axis*; the isotropy of the **product's** combined Dirac tangent is a (correct, standard) inference — at the origin the other two factors are the identity, so the product's linear jet is the sum of the axis jets — but that combined-jet statement is **not itself a theorem** here. See check 2 discussion below. |

Check 2 (isotropy / onsite / alias-distinctness):
- **Isotropic tangent — YES, per axis**, exactly `(3/5)σ_{x,y,z}`; the product-level
  isotropic Dirac cone is inferred, not kernel-checked (flagged, not a defect of
  the stated theorems).
- **Nonzero onsite — YES** (`axis_gammaZero_nonzero`, and single-axis
  `gammaZero_nonzero`).
- **Same phase convention — YES**: origin and alias are both arguments of the
  *same* `weylStep`, `z=e^{iq}` convention throughout (see §2.3).

### 2.3 `StationaryAmplitudeWeylAlias.lean`

| Theorem | Verdict | Notes |
|---|---|---|
| `corner_alias` | SOUND | `weylStep (-1) 1 (-1) = 1` exactly (2×2 identity). |
| `corner_phase_ne_origin` | SOUND | `(-1,1,-1) ≠ (1,1,1)`; distinct torus point `(q_x,q_y,q_z)=(π,0,π)` in the same `z=e^{iq}` convention as the origin. |
| `exists_distinct_identity_alias` | **SOUND / GAP** | Correct shape for "not unique-cone". **Gap:** its *physical meaning* (a genuine second cone) presupposes the symbol is **non-constant**; nothing in the three stationary-amplitude modules proves `weylStep z ≠ 1` at any point. See §7. |

The alias distinctness is genuine and in a single, consistent phase convention
(both points feed the same `weylStep`). The gap is a *vacuity-hardening* control,
not a falsity.

### 2.4 `PairedDeterminantReality.lean`

| Theorem | Verdict | Notes |
|---|---|---|
| `conjTranspose_sub_one`, `conjTranspose_sub_one_factor`, `det_one_sub_eq_det_sub_one` | SOUND | Supporting identities; `det(1−U)=det(U−1)` uses `(-1)^4=1`, i.e. the even-dimension fact the docstring calls load-bearing. |
| `star_det_sub_one_eq` | SOUND | For `UᴴU=1` and `det U=1`: `conj(det(U−I))=det(U−I)`. Hypotheses satisfiable and load-bearing. |
| `det_sub_one_im_eq_zero` | SOUND | Immediate corollary: `Im det(U−I)=0`. |

**Prose-vs-kernel note (minor).** The `star_det_sub_one_eq` docstring narrates
"two spectral sectors have paired determinant, so the full determinant is one".
The theorem only assumes `det U = 1` directly; "paired determinant across two
sectors" is *motivating prose*, not a hypothesis. Not false, but the docstring
claims more structure than the statement uses. No overclaim in the manuscript,
which correctly presents this only as a reality gate.

### 2.5 `ReciprocalCoinFamily.lean`

Convention: `c=(1−r²)/(1+r²)`, `s=2r/(1+r²)` — matches the manuscript exactly.

| Theorem | Verdict | Notes |
|---|---|---|
| `one_add_sq_pos`, `cParam_sq_add_sParam_sq` | SOUND | `c²+s²=1`. |
| `shiftCoinCommutatorR_eq`, `reciprocalRegulatorR_neg_one_eq` | SOUND | Closed forms; the `z=−1` regulator is a rotation `[[a,−b],[b,a]]`, `a²+b²=1`. |
| `coinR_mul_coinRInv`, `coinR_conjTranspose`, `coinR_unitary` | SOUND | Coin is unitary with inverse `coinRInv`. |
| `shiftCoinCommutatorR_unitary`, `reciprocalRegulatorR_unitary` | SOUND (out-of-scope dependency) | On-circle unitarity; relies on `conditionalShift_unitary`, `isUnitary2_mul` from the unread regulator file. |
| `reciprocalRegulatorR_det` | SOUND | `det = 1` on the punctured circle. |
| `reciprocalRegulatorR_one` | SOUND | `S(1)=I`. |
| `det_negOne_sub_one` | SOUND | `det(S(−1)−I)=64r²(r−1)²(r+1)²/(r²+1)⁴`. **Independently re-derived and confirmed** (zero-gap `=16c²s²`). |
| `det_negOne_add_one` | SOUND | `det(S(−1)+I)=4(r²−2r−1)²(r²+2r−1)²/(r²+1)⁴`. **Independently re-derived** (π-gap `=4(c²−s²)²`, and `(r²−2r−1)(r²+2r−1)=r⁴−6r²+1=(1+r²)²(c²−s²)`). |
| `det_negOne_sub_one_ne_zero_iff` | SOUND | Nonzero ⇔ `r≠0,±1` (i.e. `s≠0` and `c≠0`). Matches manuscript. |
| `det_negOne_add_one_ne_zero_iff` | SOUND | Nonzero ⇔ `r²−2r−1≠0 ∧ r²+2r−1≠0`. Matches manuscript. |
| `no_zero_or_pi_crossing_iff` | SOUND | Conjunction of the two. |
| `half_eq_landed_fixture` | SOUND | `r=1/2` gives `c=3/5, s=4/5`, i.e. exactly the landed 3-4-5 `reciprocalRegulator`. |
| `half_has_no_zero_or_pi_crossing` | SOUND (out-of-scope dependency) | Bridges to `neg_one_has_no_zero_or_pi_crossing` in the unread regulator file. Consistency with the manuscript's landed numbers `det(S−I)=2304/625`, `det(S+I)=196/625` **confirmed** by evaluating the in-scope formulas at `r=1/2`. |
| `zero_parameter_control` | SOUND | `r=0` is the identity coin; `S(−1)=I` and `det(S(−1)−I)=0`. This is the module's genuine *negative control*. |

This module is the strongest of the six: complete, exact, internally verified,
and it *over*-delivers versus the manuscript (it proves closed-form
determinants, not just the nonvanishing iff — the manuscript could be
strengthened to cite them, see §6).

### 2.6 `CoupledReciprocalSliceNoGo.lean`

Conventions (all confirmed against the docstring and manuscript):
`alpha3 = σ_x⊗σ_z`, `Xi = σ_x⊗I`, `coupledGenerator = σ_z⊗σ_x`,
`conditionalShift4(z)=I⊗diag(z,1)` (shift on the second factor),
`coupledCommutator z = D(z)·C·D(z⁻¹)·C⁻¹`, `coupledReciprocal z = K(z)K(z⁻¹)` —
same word order `K(z)K(z⁻¹)` as `ReciprocalCoinFamily` and the manuscript.

| Theorem | Verdict | Notes |
|---|---|---|
| `I_cube`, `I_quartic`, `fin4_mk2/3` | SOUND | Ring plumbing. |
| `coupledCoin_eq`, `coupledCoinInv_eq`, `coupledCommutator_eq`, `coupledReciprocal_eq`, `sliceWalk_eq` | SOUND | Exact numerator/denominator normal forms over Gaussian rationals. |
| `generator_anticommutes_Xi` | SOUND | `{Xi, G}=0` (since `{σ_x,σ_z}=0`). Matches "coupled generator anticommutes with Xi". |
| `coupledCoin_mul_inv` | SOUND | Coin unitary/invertible. |
| `sliceWalk_det` | SOUND | `det(sliceWalk z)=1` (the overall `−` sign is `(−1)⁴`-neutral on a 4×4 det). |
| `slice_det_sub_one` | SOUND | `= positiveQuartic(z)²/(152587890625·z⁴)`. |
| `slice_det_add_one` | SOUND | `= negativeQuartic(z)²/(152587890625·z⁴)`. |
| `positive_reduced_signs`, `negative_reduced_signs` | SOUND | `pR(1)=−55149<0<122500=pR(2)`; `nR(−1)=439059>0>−210046=nR(0)`. Matches "opposite signs on `[1,2]` and `[-1,0]`". |
| `exists_positive_reduced_root`, `exists_negative_reduced_root` | SOUND | Genuine IVT roots in `(1,2)` resp. `(−1,0)` (exact, no sampling). |
| `positive/negative_quartic_unit_circle_relation` | SOUND | On `z=cos q + i sin q`, quartic `= z²·reduced(2cos q)`; linear_combination over `sin²+cos²=1`. |
| `unit_circle_ne_zero` | SOUND | `cos q + i sin q ≠ 0`. |
| `exists_additional_zero_crossing`, `exists_additional_pi_crossing` | **SOUND / narrow** | **Genuine physical unit-circle roots** (`|z|=1` by construction) at **nonzero momentum** (`q≠0` proved via `arccos` and `cos q = x/2 ∈ (1/2,1)` resp. `(−1/2,0)`), **with no sampled/approximate data** — exactly as the manuscript claims. **Narrowing:** the word *"additional"* is not certified by the kernel; see below. |

Check 3 (coupled root existentials): **PASS.** The roots are on the true unit
circle (`z = cos q + i·sin q`, and `unit_circle_ne_zero` plus `sin²+cos²=1`),
have nonzero momentum (`q≠0` is proved, not assumed), and are produced by
IVT + exact algebra over Gaussian rationals — the module docstring's "no sampled
or approximate crossing claim is used" holds. `det(U−I)=0` ⇔ eigenvalue `+1`
(zero quasienergy) and `det(U+I)=0` ⇔ eigenvalue `−1` (π quasienergy), so the
sign convention is the physically correct one and is consistent with
`ReciprocalCoinFamily` (zero-gap = `U−I`, π-gap = `U+I`).

**Overclaim risk — the word "additional".** The theorems prove *existence of a
crossing at `q_z≠0`*. They do **not** locate the *intended* Dirac node(s) of this
slice, so "additional crossing" (extra to the design) is an inference from the
architecture's intent, not a kernel fact. Because `slice_det_sub_one/add_one`
are non-zero rational functions (numerator a nonzero quartic-squared), the
crossings are at least *isolated*, so the no-go is not vacuous; but "additional"
should read "there exists a nonzero-momentum crossing on the slice" unless a
companion theorem pins the design node and shows the found `q_z` differs. This is
the coupled-route half of the missing-control finding (§7).

---

## 3. Vacuity / hollow-telescoping / false-shape sweep (check 1)

- **Vacuity:** No theorem has an unsatisfiable hypothesis set. The recurring
  `z≠0` + `conj z = z⁻¹` pair is satisfied by every genuine unit-circle point
  (e.g. `z=I`, `z=−1`, `z=cos q+i sin q`), and the explicit
  `explicit_stationary_walk_unitary` / capstone theorems instantiate it.
- **Hollow telescoping:** The determinant closed forms
  (`ReciprocalCoinFamily`, `CoupledReciprocalSliceNoGo`) and the Laurent
  expansion are *substantive* normal-form computations, not `def`-unfolding
  restatements. The one place where a *conclusion* is thinner than it reads is
  `exists_distinct_identity_alias` (protected only by inference — §7) and the
  "additional" wording in the coupled no-go (§2.6).
- **Prose outrunning the kernel:** three concrete instances, all *narrowings*
  not falsehoods — (a) product-level isotropic Dirac jet inferred not proved
  (§2.2); (b) "additional" crossing (§2.6); (c) the `PairedDeterminantReality`
  docstring's "two spectral sectors / paired determinant" gloss (§2.4). Plus the
  cross-file cases where the *manuscript* cites facts living in the unread
  regulator module (§5).
- **False mathematical shape:** none found. Two determinant closed forms
  (`det_negOne_sub_one`, `det_negOne_add_one`) and the landed numbers
  (`2304/625`, `196/625`) were re-derived by hand and match. All sign/gap
  conventions line up.

---

## 4. Convention consistency (check 4)

| Convention | Coin family | Coupled slice | Stationary route | Manuscript | Verdict |
|---|---|---|---|---|---|
| determinant one | `reciprocalRegulatorR_det` | `sliceWalk_det` | (unitarity, det one implicit) | "det `S`=1", "det `U`=1" | consistent |
| word/factor order `K=D C D⁻¹ C⁻¹`, `S=K(z)K(z⁻¹)` | `shiftCoinCommutatorR`, `reciprocalRegulatorR` | `coupledCommutator`, `coupledReciprocal` | n/a (projector word) | `K(z)=D(z)CD(z⁻¹)C⁻¹`, `S=KK` | consistent |
| register / tensor order | 2-band | `α₃=σ_x⊗σ_z`, `Ξ=σ_x⊗I`, `G=σ_z⊗σ_x`, shift on 2nd factor | 2-band (`σ_x,σ_y,σ_z`) | same, verbatim | consistent |
| zero-gap = `U−I`, π-gap = `U+I` | `det_negOne_sub_one` / `_add_one` | `slice_det_sub_one` / `_add_one` | n/a | "zero-gap" / "π-gap" | consistent |
| phase convention `z=e^{iq}`, origin `z=1` | `z=−1`↔`q=π` | `z=cos q+i sin q` | `weylStep` origin `(1,1,1)`, alias `(−1,1,−1)` | `z=exp(i q_z)` | consistent |
| even dimension load-bearing | — | 4×4 | — | "even dimension is load-bearing" | consistent |

No register-order, factor-order, determinant, or 0/π sign inconsistency was
found across the six modules or against the cited prose.

---

## 5. Manuscript sentence-by-sentence support (check 6), lines 1640–1740

Grouped by paragraph; each verdict is **Supported**, **Narrow** (needs
narrowing), **Strengthen** (can be strengthened), or **Out-of-scope** (true of
the program but not backed by any of the six cited modules).

1. Doubled-commutator negative-control paragraph ("…all cubic 0/π corners as at
   the origin … obstruction belongs to the doubled commutator architecture, not
   phase gates individually"): **Out-of-scope** — refers to earlier modules not
   in the audit set; architecture-level framing is appropriate.
2. First primitive `S(z)=K(z)K(z⁻¹)`: unitary, `det S=1`, `S(1)=I`,
   `S(z)−I=(z−1)²Q(z)`, five Laurent coefficients at powers `−2..2`, both
   range-two coefficients nonzero, zeroth moment `=I`, first moment vanishes,
   `det(S−I)=2304/625`, `det(S+I)=196/625`: **Out-of-scope** — these live in
   `ReciprocalConditionalShiftRegulator` (not read). The two determinant numbers
   are **cross-checked Supported** via `ReciprocalCoinFamily` at `r=1/2`.
3. Coin-family classification (`c=(1−r²)/(1+r²)`, `s=2r/(1+r²)`; unitary, det one;
   zero-gap nonzero ⇔ `r≠0,±1`; π-gap nonzero ⇔ away from roots of `r²∓2r−1`;
   `r=1/2` is the 3-4-5 member; `r=0` is the identity control): **Supported**
   by `ReciprocalCoinFamily`, verbatim. **Strengthen:** the module proves exact
   closed-form determinants, not merely the iff — the prose could cite the
   closed forms.
4. Reality gate (`conj det(U−I) = det(U−I)` for unitary 4×4 with `det U=1`;
   "real endpoint values alone do not make `det(U(q)−I)` real along a path";
   "family-level reciprocal sign oracle therefore remains conditional …"):
   **Supported** by `PairedDeterminantReality` and correctly labelled as a
   reusable *reality gate, not a root-existence theorem*. The converse caution is
   a hedge, not a claimed theorem (no counterexample formalized) — acceptable.
5. Coupled-slice no-go ("regulator noncentral … leaves the Dirac first jet only
   at quadratic order"; "on the slice `q_x=π,q_y=0`, zero/π determinants reduce
   to squared reciprocal quartics"; "reduced factors have opposite signs on
   `[1,2]` and `[-1,0]`"; "creates at least one additional crossing of each
   quasienergy on that slice"; "Lean proves both physical unit-circle
   existentials exactly … `arccos`, `q_z≠0`"; "`\NoGo{}` … not a universal
   reciprocal no-go … diagnostic … enlarged register is the next honest test"):
   - "quadratic-order first jet": **Narrow / Out-of-scope** — no jet-vanishing
     theorem exists in `CoupledReciprocalSliceNoGo`; this is design motivation,
     not a cited-module theorem.
   - squared-quartic reduction, opposite signs, exact unit-circle existentials,
     `q_z≠0`: **Supported**.
   - "at least one **additional** crossing": **Narrow** — supported as "at least
     one nonzero-momentum crossing on the slice"; "additional" (vs a design
     node) is not kernel-certified (§2.6, §7).
   - architecture-/not-universal fencing: **Supported**, and this is the central
     boundary held correctly.
6. Stationary-amplitude primitive (arbitrary noncommuting `P,Q`; range-one
   Laurent `U=zΓ₊+Γ₀+z⁻¹Γ₋`, exactly unitary; witness
   `Γ₀=[[16/25,−12/25],[12/25,16/25]]≠0`; "necessary `z≠0` and correct
   same-family adjoint laws were enforced after the originally proposed formulas
   failed"): **Supported** by `StationaryAmplitudeProjectorWalk`, including the
   honest record of the corrections.
7. Isotropic tangent (three noncommuting pairs with first moments exactly
   `(3/5)σ_{x,y,z}`; nonzero onsite on each axis; ordered product exactly unitary
   for every torus momentum and `=I` at origin; "strict locality, stationary
   amplitude, all-zone unitarity, and an isotropic Weyl first jet are
   compatible"): **Supported** for the per-axis moments and all-torus unitarity;
   **Narrow** on "isotropic Weyl first jet" *of the product symbol* (per-axis is
   proved; the combined Dirac tangent is inferred — §2.2).
8. First global test / alias (`(-1,1,-1)` gives exactly `I`; matrix equality and
   distinctness from `(1,1,1)` are kernel; "not unique-cone"; oracle finds two
   more off-corner roots but census/those roots are outside the kernel):
   **Supported** as stated, **with the §7 caveat** that non-triviality of the
   symbol is not itself in the kernel, so "not unique-cone" is meaningful only
   given (correct but unformalized) non-constancy.

---

## 6. Where the manuscript can be *strengthened*

- Paragraph 3: cite the **exact closed-form corner determinants**
  (`det_negOne_sub_one`, `det_negOne_add_one`) rather than only the nonvanishing
  iff — they are already proved.
- Paragraph 8 / §7: once the tiny non-constancy control below is added, the
  "not unique-cone" claim upgrades from *inference-protected* to
  *kernel-protected*, and the alias becomes an unambiguous statement about a
  genuinely non-constant symbol.

---

## 7. Smallest exact negative control missing (check 7)

Two routes each miss a small control; the **single smallest and most decisive**
is on the **stationary-amplitude / alias route**:

> **Add an exact non-constancy witness for `weylStep`:** a one-line
> `norm_num`/`fin_cases` lemma of the form
> `weylStep I 1 1 ≠ 1` (or any concrete off-corner torus point where the ordered
> symbol is *not* the identity).

Why this is the right control, and why it is currently absent:
`StationaryAmplitudeWeylTangent` and `StationaryAmplitudeWeylAlias` prove
`weylStep 1 1 1 = 1` and `weylStep (-1) 1 (-1) = 1`, but **nothing** in the three
stationary-amplitude modules proves the symbol is ever `≠ 1`. Consequently
`exists_distinct_identity_alias` — the flagship "not unique-cone" no-go — is only
protected against the degenerate reading "`weylStep ≡ 1` everywhere" by the
*inference* that nonzero first moments `(3/5)σ` force `z`-dependence of each axis
walk. That inference is correct but not in the kernel, so as written the alias
theorem is *hollow-proof-resistant only by argument, not by proof*. The proposed
witness is a couple of lines, needs no new API, and converts the alias claim into
a genuine statement about a demonstrably non-constant symbol. It is the smallest
exact control that removes a real vacuity risk.

Runner-up (coupled route), for completeness: pin the **intended** slice node so
that "additional" is earned — e.g. an exact lemma exhibiting the *designed*
zero-quasienergy momentum on the slice and showing the IVT-produced `q_z` differs
from it (or, minimally, an exact evaluation such as `det(sliceWalk 1 - 1)` at the
symmetric baseline to anchor the comparison). This is strictly larger than the
`weylStep` witness, hence secondary.

---

## 8. Summary judgement

- **Mathematics:** all six modules are sound; two nontrivial determinant closed
  forms and the landed `2304/625`, `196/625` numbers were re-derived and match;
  all conventions are mutually consistent and consistent with the cited prose.
- **Scope discipline:** the two no-gos are correctly fenced as
  architecture-level (coupled: even slice-level), never universal; the reality
  gate is correctly presented as conditional. The central boundary holds.
- **Overclaims:** none rise to falsity. Three narrowings (product-level isotropy
  inferred; "additional" crossing not node-anchored; `PairedDeterminantReality`
  docstring's "paired sectors" gloss) and several manuscript sentences that rely
  on the unread `ReciprocalConditionalShiftRegulator` module.
- **Missing control:** a one-line `weylStep z ≠ 1` non-constancy witness is the
  smallest exact negative control absent from either route, and it is what
  upgrades `exists_distinct_identity_alias` from inference-protected to
  kernel-protected.

*Verdict is deliberately hostile and is allowed to be negative: the constructions
are honest and kernel-checked, but the alias route ships without the small
non-triviality control that its physics interpretation requires, and two prose
qualifiers ("isotropic first jet" at product level, "additional" crossing) run
slightly ahead of the kernel.*
