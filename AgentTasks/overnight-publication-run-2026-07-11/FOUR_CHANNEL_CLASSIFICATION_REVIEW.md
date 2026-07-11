# Hostile classification-design review: four-channel carrier decompositions

> **Post-integration correction (2026-07-10, Codex).** The returned package
> described a companion `ChannelClassificationReview.lean` and theorem names
> that were not integrated into the live tree. Treat every reference below to
> that file, `even_sector_moduli_nontrivial`, or
> `commuting_involutions_decomposition_unique` as design evidence, not a live
> declaration. The independently built replacements are
> `ChannelShearModuli.mixed_shear_injective`,
> `ChannelRefinementTorsor.refinementEquivZeroSumShift` and
> `refinement_not_unique_of_nonzero`, and
> `ChannelSelectorUniqueness.two_sign_gradings_decomposition_unique`. The full
> type-only fixed-total fibre is now classified by zero-sum additive shifts;
> the selector-preserving physical quotient remains open.

Review of `CarrierRigidity.lean`, `GradedDecompUniqueness.lean`,
`UnifiedMassBudget.lean`, `FourChannelRigidityCapstone.lean`, and the two program
notes. This is a strategy/formalization-design audit; it does **not** edit the
existing theorem files. The companion-file claims in the original return were
superseded by the live modules named in the correction above.

The report is organized as required: (0) audit findings graded
`FATAL/MAJOR/MINOR/CLEAR`; (1–10) the ten design questions with Lean-shaped
pseudocode; then prohibited weakenings, circular selectors, the theorem
dependency DAG, and an honest publication headline.

---

## 0. Findings on the current reading

### CLEAR (correct, load-bearing, reusable)

- **`CarrierRigidity.parity_decomposition_unique`.** Genuine: the split of an
  element of a ring into a `Γ`-even and a `Γ`-odd part is unique. Uses `2`
  invertible. This is the *one* honest uniqueness result at the axiom level.
- **`square_oddPart` / `square_evenPart`.** Genuine and sharp: the odd part of the
  square is exactly `2·E_#`; the even part is `Q_A + Q_C + 2·Q_T`. So chirality
  canonically isolates soldering and **lumps** aperture+closure+turn. This is the
  correct statement of what the grading does and does not do.
- **`CarrierRigidity.Concrete.shared_type_but_distinct`** (and
  `channels_pairwise_distinct`). Genuine and strong: an explicit `4×4` rational
  Krein carrier satisfying *all* axioms in which `Q_A, Q_C, Q_T` are pairwise
  distinct, nonzero, and share the identical `(Γ,#)`-type. This is a real
  non-rigidity witness, not a rephrasing.
- **`NullEdgeCloser.blocks_eq_eigenspaces` / `decomposition_unique`.** Genuine and
  reusable: given a grading operator `D` acting as *distinct* scalars `μ i` on the
  blocks of an internal direct sum, each block equals `D.eigenspace (μ i)`, so the
  decomposition is unique. This is the actual selector theorem the program needs,
  and it is stated at the right level of generality (any field, any `Fintype`
  index).

### MAJOR (true as stated, but the *framing* over-claims or is disconnected)

- **The "exact four-term expansion" is essentially definitional.**
  `square_decomposition` proves `2·(D#D) = Q_A + Q_C + 2·E_# + 2·Q_T`, but
  `apertureQ`, `closureQ`, `solderE`, `turnQ` are *defined* as the corresponding
  groupings of monomials; the theorem is a `noncomm_ring` rearrangement that uses
  only `Γ²=1, star Γ=Γ, star φ=φ` (it does **not** use `cₑ²=0` or the
  anticommutation `{Γ,cₑ}=0`). "No fifth block" is therefore a **bookkeeping
  identity about a chosen grouping**, not a rigidity fact. It is exactly the
  "a vector sum can be rewritten" observation the design brief warns against. The
  content lives entirely in the *parity* classification of those groupings (which
  does use the anticommutators).
- **Three artifacts, three different carriers and normalizations, never
  cross-checked.**
  - `CarrierRigidity`: `2·D#D = Q_A + Q_C + 2E_# + 2Q_T` (abstract `StarRing`).
  - Context pack manuscript: `4·D#D = Q_A + Q_C + 4Q_T + 4E_#`.
  - `UnifiedMassBudget`: `4·(Dᵀ·D) = QA + QC + QT + Es` with a *different* `4×4`
    `D` and coefficients `(1,1,1,1)`.
  The concrete `UnifiedMassBudget.QA/QC/QT/Es` are **hand-placed matrices** whose
  only proven relation to the operator is `square_splits` plus parity; they are
  **not** computed from `apertureQ/closureQ/solderE/turnQ`. Worse, their supports
  are inconsistent with the `CarrierRigidity.Concrete` channels (there
  `apertureC = diag(0,0,4,10)`, supported on the *odd*-labelled indices `2,3`;
  here `QA = diag(8,0,0,0)`, supported on index `0`). These are two unrelated
  examples wearing the same names. No single carrier instantiates the abstract
  identity, the parity theorem, and the coordinate witness together.
- **`FourChannelRigidity` coefficient recovery is circular by construction.** The
  readers `readA/readC/readT/readE` are entry selectors normalized by the target
  channel's own value; linear independence of `QA,QC,QT,Es` is immediate from
  *disjoint supports*. So "coefficient-rigid once its coordinate/support selectors
  are supplied" says: *after* fixing the answer's support pattern, the answer is
  determined. The file honestly flags this ("does not claim an abstract canonical
  split"), but the phrase "coefficient rigidity" should not be read as evidence
  for canonicity. This is the circular selector to avoid (see §"Circular
  selectors").
- **`FourChannelRigidityCapstone.lean` does not elaborate in the delivered
  project.** It imports `PhysicsSM.Draft.NullEdge.*`, which do not exist here
  (`unknown module prefix 'PhysicsSM'`). So `four_channels_linearIndependent`,
  `carrier_square_coefficients_recovered`, and
  `four_channel_rigidity_with_boundary` are **not kernel-checked in this package**
  as shipped. The fix is mechanical (retarget the imports to the top-level module
  names `UnifiedMassBudget`, `CarrierRigidity`, `GradedDecompUniqueness`), but as
  delivered the "kernel-checked" status of the capstone is unmet.

### MINOR

- **`NullEdgeCloser.split_not_forced` is generic, not carrier-specific.** It
  exhibits two complementary decompositions of `ℝ²` — a true but content-free
  linear-algebra fact with no tie to the carrier. It should be presented as an
  *illustration* that "fixed block count ⇏ fixed split," not as a carrier no-go.
  The carrier-specific no-go is `shared_type_but_distinct`.
- **`answers_detP` (`totalBudget = c·det P`, `c = 1184/75`).** The constant `c` is
  chosen to make two numbers equal (`3552 = c·225`); as stated it is a numerical
  identity, not a structural link between the Frobenius budget and the Plücker
  invariant. The `UnifiedMassBudget` docstring already marks the physics reading
  as "narrative, not proved" — keep it that way; do not let `c` migrate into any
  theorem *statement* as if it were derived.
- **Frobenius "budget" additivity relies on disjoint supports**, i.e. it is again
  a consequence of the hand-chosen support pattern, not an intrinsic feature.

### FATAL (only for over-strong readings; none for the checked math itself)

- No checked statement in the package supports "**the four channel types are
  forced**" or "**canonical four-channel decomposition**" for a general carrier.
  The checked results prove the opposite at the axiom level
  (`shared_type_but_distinct`) and prove uniqueness only *after* adding a distinct-
  eigenvalue grading operator (`decomposition_unique`) or *after* fixing support
  coordinates (`FourChannelRigidity`). Any paper sentence asserting intrinsic
  four-channel canonicity from `(Γ,#)` alone is contradicted by the package's own
  witness and must be struck (see §9).

---

## 1. Objects: `CarrierDatum`, `ChannelDecomposition`, selector-preserving equivalence

Design principle: the carrier holds only the *algebra and its two intrinsic
structures* (Krein adjoint, chirality). Everything used to *name* the four
channels — solder-degree count, edge-index symmetrization, support coordinates —
is **not** carrier data; putting it in the carrier is the circular move.

```lean
/-- Intrinsic carrier data: a finite Krein module with its adjoint (`StarRing`),
a chirality involution `Γ`, and the generators. The two intrinsic structures are
`#` (`star`) and `Γ`. -/
structure CarrierDatum (R : Type*) [Ring R] [StarRing R] where
  Γ  : R
  φ  : R
  c  : Fin n → R          -- soldering directions (null: `c e * c e = 0`)
  g  : Fin n → R          -- transports
  Γsq   : Γ * Γ = 1
  Γstar : star Γ = Γ
  φstar : star φ = φ
  cnull : ∀ e, c e * c e = 0
  Γc    : ∀ e, Γ * c e = -(c e * Γ)     -- {Γ, c} = 0
  Γg    : ∀ e, Γ * g e = g e * Γ        -- [Γ, ∇] = 0
  Γφ    : Γ * φ = φ * Γ

/-- A decomposition of a target element `T` (here `T = 2 • D#D`) into finitely
many components, each carrying ONLY intrinsic type data: parity and adjoint type.
Word/solder degree and edge-symmetry are deliberately NOT fields — they are the
selectors of §4/§5, not part of the object. -/
structure ChannelDecomposition (R) [Ring R] [StarRing R] (T : R) (m : ℕ) where
  comp    : Fin m → R
  sums    : (∑ i, comp i) = T
  parity  : Fin m → Bool                        -- declared Γ-parity
  parityOK   : ∀ i, if parity i then Γ * comp i = comp i * Γ
                               else Γ * comp i = -(comp i * Γ)
  selfadj : ∀ i, star (comp i) = comp i         -- declared #-type
```

**Selector-preserving equivalence.** Two decompositions are equivalent when a
symmetry of the *carrier* carries one to the other while preserving *every
retained selector*. At the type-only level (parity + adjoint) the symmetry group
is generated by

1. carrier isomorphisms (`#`- and `Γ`-preserving ring isomorphisms `Φ`);
2. gauge conjugation by a `#`-unitary commuting with `Γ`;
3. edge relabelling (`Sₙ` on the index of `c,g`);
4. changes of channel coordinates that fix `parity` and `selfadj`.

```lean
def SelectorEquiv (T) : ChannelDecomposition R T m → ChannelDecomposition R T m → Prop :=
  fun X Y => ∃ σ : Equiv.Perm (Fin m), ∃ Φ : CarrierAut R,
    (∀ i, Y.comp i = Φ (X.comp (σ i))) ∧
    (∀ i, Y.parity i = X.parity (σ i))          -- parity preserved
    ∧ (Φ preserves star and Γ)                   -- adjoint/chirality preserved
```

**What belongs to the carrier vs. what would be circular.**

| Datum | Carrier? | Reason |
|---|---|---|
| `#` (Krein adjoint), `Γ` | **Yes** | the two intrinsic structures of the problem |
| null solder directions `c e`, transports `g e`, turn `φ` | **Yes** | generators of `D` |
| declared parity, declared `#`-type | Yes (of a *decomposition*) | intrinsic to each component |
| **solder/word degree** (# of `c`-letters) | **No — selector** | needs a chosen filtration/grading operator (§4) |
| **edge-exchange symmetrization** (`Q_A` sym / `Q_C` antisym) | **No — selector** | needs a chosen `Sₙ`-action operator |
| **support/coordinate readers** (`readA…readE`) | **No — circular** | encodes the desired answer's support (§0 MAJOR) |

---

## 2. The smallest nontrivial type-only moduli theorem

The design brief demands more than "a sum can be regrouped." Here is the group
action, the torsor, and the nondegeneracy conditions.

**Setup.** Fix the intrinsic (parity + adjoint) type. By `square_evenPart` the
even sector `S := Q_A + Q_C + 2·Q_T` is a *single* canonical object; the odd
sector `2·E_#` is canonically fixed (`square_oddPart`). A "type-only refinement"
of the even sector into three `Γ`-even, `#`-self-adjoint pieces with fixed total
`S` is a point of

```
  Ref(S) := { (A, C, T) : A,C,T are Γ-even, #-self-adjoint, A + C + T = S }.
```

**Group action / torsor.** Let

```
  H := { (a, c, t) : a,c,t Γ-even, #-self-adjoint, a + c + t = 0 }
```

be the additive group of *type-preserving traceless shifts*. Then `H` acts freely
and transitively on `Ref(S)` by translation `(A,C,T) + (a,c,t)`. Hence:

```lean
/-- Type-only moduli theorem (shape). The even-sector refinements form an
`H`-torsor; in particular the "forget the refinement, keep the total" map
`Ref(S) → {S}` has fibre canonically `≅ H` (an affine space), so it is a point
iff `H = 0`. -/
theorem even_refinement_is_H_torsor :
    IsTorsor H (Ref S)               -- free + transitive translation action
```

**Nondegeneracy conditions (when the moduli is nontrivial).** `H ≠ 0` — i.e. the
split is genuinely underdetermined — exactly when the space of `Γ`-even,
`#`-self-adjoint elements has dimension `> 0` beyond what any *intrinsic* second
grading fixes. Sufficient explicit condition: there exists a nonzero `Γ`-even,
`#`-self-adjoint `b` supported inside the even sector; then `(b,-b,0) ∈ H \ {0}`.

**Checked witness (in `ChannelClassificationReview.lean`).** With `b = bump`
(diagonal, even block) over the `UnifiedMassBudget` even channels, the one-
parameter family `s ↦ (QA + s·b, QC − s·b, QT)` is an injective map
`ℚ ↪ Ref(QA+QC+QT)`:

- `refine_total`  : fixed total `QA + QC + QT`;
- `refineA_even`, `refineC_even`  : `Γ`-even in every slot;
- `refineA_symm`, `refineC_symm`  : `#`-self-adjoint (`= transpose`) in every slot;
- `refineA_injective`, `triple_injective`  : distinct `s` ⇒ distinct refinement;
- `even_sector_moduli_nontrivial`  : `∃` injective one-parameter family with the
  fixed total.

So `dim Ref ≥ 1`: **type-only data cannot separate aperture/closure/turn.** This
is the correct, non-vacuous type-only moduli statement (an affine variety / `H`-
torsor with an explicit nonzero tangent direction), not a regrouping.

---

## 3. Lean theorem ladder for an explicit inequivalent even-sector family

Stated against the finest label-preserving equivalence (equality of ordered
triples), which is the *initial* (strongest) relation; any coarser physical
equivalence is a quotient of it. All of the following are **kernel-checked** in
`ChannelClassificationReview.lean` (namespace `ChannelClassificationReview`,
axioms `[propext, Classical.choice, Quot.sound]`).

```lean
def bump    : M4      := !![1,0,0,0; 0,0,0,0; 0,0,0,0; 0,0,0,0]
def refineA (s : ℚ) : M4 := QA + s • bump
def refineC (s : ℚ) : M4 := QC - s • bump
def refineT           : M4 := QT
def triple  (s : ℚ) : M4 × M4 × M4 := (refineA s, refineC s, refineT)

theorem refine_total   (s) : refineA s + refineC s + refineT = QA + QC + QT
theorem refineA_even   (s) : Gam * refineA s * Gam = refineA s
theorem refineC_even   (s) : Gam * refineC s * Gam = refineC s
theorem refineA_symm   (s) : (refineA s)ᵀ = refineA s
theorem refineC_symm   (s) : (refineC s)ᵀ = refineC s
theorem family_shares_type (s) :   -- identical retained type data for every s
    refineA s + refineC s + refineT = QA + QC + QT ∧
    Gam*refineA s*Gam = refineA s ∧ Gam*refineC s*Gam = refineC s ∧
    (refineA s)ᵀ = refineA s ∧ (refineC s)ᵀ = refineC s
theorem triple_injective : Function.Injective triple      -- genuine inequivalence
theorem even_sector_moduli_nontrivial :
    ∃ f : ℚ → M4×M4×M4, Function.Injective f ∧
      ∀ s, (f s).1 + (f s).2.1 + (f s).2.2 = QA + QC + QT
```

**Why this is "genuinely inequivalent" and not a triviality.** The *equivalence
relation is explicit* (ordered-triple equality, refined by the type-preserving
gauge group `{id, transpose, Γ-conjugation}`, each of which *fixes* every member
because members are self-adjoint and even). Under that relation distinct `s` are
inequivalent (`triple_injective`), while `family_shares_type` shows the retained
selectors are constant along the family. That is the exact separation the program
needs: **inequivalent as decompositions, identical as typed data.**

---

## 4. Abstract commuting-involution / commuting-idempotent uniqueness theorem

**Theorem (checked, `commuting_involutions_decomposition_unique`).** Let `V` be a
real vector space and `P, Q : End ℝ V` act as the sign scalars `±1` on the blocks
of a `Bool × Bool`-indexed internal direct sum (`P` reads the first sign, `Q` the
second). Then any second internal decomposition graded by the same `(P,Q)` sign
pattern **coincides** with it: `W = W'`.

```lean
theorem commuting_involutions_decomposition_unique
    (P Q : Module.End ℝ V)
    (W W' : Bool × Bool → Submodule ℝ V)
    (hInt : DirectSum.IsInternal W) (hInt' : DirectSum.IsInternal W')
    (hPW  : ∀ ij, ∀ x ∈ W ij,  P x = sgn ij.1 • x)   (hQW  : ∀ ij, ∀ x ∈ W ij,  Q x = sgn ij.2 • x)
    (hPW' : ∀ ij, ∀ x ∈ W' ij, P x = sgn ij.1 • x)   (hQW' : ∀ ij, ∀ x ∈ W' ij, Q x = sgn ij.2 • x) :
    W = W'
```

**Reduction (the design idea).** A *single separating grade* `D := P + 2·Q` acts on
sector `(i,j)` by `sgn i + 2·sgn j ∈ {3,1,-1,-3}`, four *distinct* values
(`sgn_grade_injective`). So `NullEdgeCloser.decomposition_unique` applies verbatim.
This is the general mechanism: **two commuting involutions ⇒ one grading operator
with distinct eigenvalues ⇒ unique joint eigenspace decomposition.** Idempotents
`e = (1+P)/2` give the same statement.

**Instantiation on the live carrier, and the honest flags.**

- **Chirality parity `Γ`** is a genuine intrinsic involution (`Γ²=1`), commuting
  with the transports and turn. It supplies the *first* factor `P`. This is real.
- **Solder/word degree** (turn has `0` `c`-letters, aperture/closure have `2`)
  *would* supply a second grading separating `Q_T` from `{Q_A,Q_C}` — **but it is
  not an intrinsic operator**: "number of `c`-letters" is a filtration on the free
  presentation, not a conjugation-invariant involution on the algebra. Flag:
  **not intrinsic** (basis/presentation-dependent).
- **Edge exchange** (symmetric `Q_A` vs antisymmetric `Q_C`) *would* supply the
  third separation — but it is an operator on the *edge index* `Fin n`, i.e. it
  requires a chosen `Sₙ`-action; on the raw algebra it need not commute with `Γ`
  or with the solder-degree grading, and the concrete witness
  (`shared_type_but_distinct`) proves that *no intrinsic* `(Γ,#)`-definable second
  involution separates `Q_A,Q_C,Q_T` (they share type yet differ). Flag: **not
  intrinsic and not guaranteed to commute**.

So the abstract theorem is exactly the selector that would close the program; the
package's own witness shows the required *second commuting intrinsic involution
does not exist* from `(Γ,#)` alone. Any additional grading must be **added as
explicit structure** (a chosen edge involution + a chosen degree operator), and
its intrinsicness/commutation are the two things a paper must prove, not assume.

---

## 5. Ranking the candidate selectors

By (a) mathematical independence from the intrinsic `(Γ,#)` data and (b) likely
power to cut the moduli `Ref(S)`:

| Rank | Selector | Independence | Moduli-reduction power | Intrinsic? |
|---|---|---|---|---|
| 1 | **Refinement/RG naturality** | high | high — closure under blocking forces a functorial channel algebra; if it fails, replaces "4 channels" by a classified effective algebra | conditionally (needs a refinement functor) |
| 2 | **Locality / causal support** | high | high — support on graph stars/edges is exactly a second grading (edge involution + degree); this is the natural home of §4's missing involutions | **no** (needs graph structure), but physically canonical |
| 3 | **Physical (reflection) positivity** | medium | medium — picks a positive cone, can single out `Q_A` (aperture) but leaves signed `Q_C` ambiguous; interacts with, not orthogonal to, locality | no |
| 4 | **Gauge/frame covariance** | medium | medium — cuts the gauge orbit but not the *within-type* affine moduli `H` | partially |
| 5 | **Checkerboard compatibility** | low–medium | medium on bipartite carriers; degenerate otherwise | no |
| 6 | **Information monotonicity** | medium | low–medium for *separation* (it constrains coarse-grainings, not the fine split); high as a *consistency* check | no |
| 7 | **Physical positivity of `Q_C`** | low | low — `Q_C` is genuinely signed (`closure_val` etc.), so positivity cannot canonicalize it | no |

Independence note: locality and RG-naturality are the two *independent* levers;
positivity, checkerboard, and gauge covariance are largely *downstream* of
locality; information monotonicity is nearly orthogonal to all of them but weak on
the fine split. **The moduli-killing pair to bet on is (locality/causal-support)
× (refinement-naturality)** — together they instantiate the §4 theorem with two
genuinely commuting graded operators (edge-support parity and solder degree).

---

## 6. Necessary-and-sufficient selector theorem, and the sharp no-go

**Publishable N&S theorem (target shape).**

```lean
/-- The even-sector split is unique up to `SelectorEquiv` IFF the carrier admits a
pair of commuting, `#`-self-adjoint, `Γ`-commuting operators (E, N) — an edge-
exchange involution `E` and a solder-degree grading `N` — whose joint spectrum
separates the three even channels, i.e. the combined grade `Γ ⊕ E ⊕ N` takes a
distinct value on each of {A, C, T}. -/
theorem even_split_unique_iff_separating_grades :
    (∃! refinement up to SelectorEquiv) ↔
      (∃ E N : End, commute Γ E ∧ commute Γ N ∧ commute E N ∧
        star E = E ∧ star N = N ∧
        Function.Injective (jointGrade Γ E N ∘ channelOf)) := by
  -- (⇐) is `commuting_involutions_decomposition_unique` generalized to 3 factors;
  -- (⇒) is the contrapositive of `shared_type_but_distinct`.
  sorry
```

The `⇐` direction is already essentially proved (§4, generalize `Bool×Bool` to
`Bool×Bool×Bool` / `Fin 3` grades via `decomposition_unique`). The `⇒` direction
is delivered in skeleton by the non-rigidity witness: if no separating grade
exists, `shared_type_but_distinct` exhibits two members related by no selector-
preserving map.

**Sharp residual-moduli no-go (if uniqueness fails).**

```lean
/-- If every intrinsic (Γ,#)-definable operator commuting with Γ acts by a scalar
on the even sector, then the even-sector refinements form a nontrivial affine
`H`-torsor (dim H ≥ 1), and no `SelectorEquiv` collapses it: the residual moduli
is exactly `H`. -/
theorem residual_moduli_no_go
    (hscalar : ∀ N : End, commute Γ N → star N = N →
        ∃ λ, ∀ x ∈ evenSector, N x = λ • x) :
    ¬ (∃! refinement up to SelectorEquiv) ∧ Ref(S) ≃ H  := by
  sorry   -- built on even_refinement_is_H_torsor + shared_type_but_distinct
```

The checked lower bound `even_sector_moduli_nontrivial` (§3) already provides the
`dim H ≥ 1` half on the concrete carrier, so the no-go is not vacuous.

---

## 7. Nearest literatures and the precise novelty boundary

- **Weitzenböck / superconnection / Bochner–Lichnerowicz decompositions.** `D²`
  splitting into a connection Laplacian plus curvature/potential terms is classical
  (Bismut superconnections; Lichnerowicz `D² = ∇*∇ + R/4`). *Boundary:* those are
  canonical because the summands are *intrinsically typed* (a Laplacian vs. a
  zeroth-order curvature); the present carrier's novelty claim is precisely that in
  the finite Krein setting the analogous typing is **not** intrinsic
  (`shared_type_but_distinct`). Novelty = the failure of Weitzenböck canonicity and
  its exact moduli.
- **Simultaneous eigenspace / joint spectral decompositions.** Commuting normal
  operators ⇒ unique joint spectral projections (finite-dim: commuting
  diagonalizable operators). `decomposition_unique` is the finite algebraic core of
  this. *Boundary:* standard; the carrier contribution is only the *instantiation
  question* — which physical operators are the commuting family.
- **Invariant theory / moduli of Dirac operators for finite spectral triples**
  (Krajewski; Paschke–Sitarz; Chamseddine–Connes finite geometry; "Moduli spaces of
  Dirac operators for finite spectral triples", arXiv:0902.2068). This is the
  closest neighbour: moduli of finite Dirac data modulo unitary/Krein equivalence.
  *Boundary:* those classify the *operator* `D` in a fixed spectral triple; the
  present question classifies *decompositions of `D#D`* modulo selector-preserving
  equivalence — a different quotient (channels, not carriers).
- **Operator systems / positive cones.** Positivity-based selection of a preferred
  decomposition = choosing an order structure on an operator system. *Boundary:*
  applicable to `Q_A` (aperture positive) but provably not to signed `Q_C`; so
  positivity is a *partial* selector here, a known phenomenon.
- **Quantum resource theories / data-processing monotones.** Information-selector
  (§F5) = a resource-monotone characterization of a channel. *Boundary:* resource
  theories classify *maps* by monotones; using a monotone to *fix a summand of an
  operator* is nonstandard and is the genuinely novel-if-it-works direction — but
  §5 ranks its separating power low.

**Novelty boundary in one line:** the mathematically new object is *the moduli
space of even-sector refinements of a finite Krein–Dirac carrier square and the
selector conditions that collapse it* — not the square identity (Weitzenböck-type,
here definitional) nor the joint-eigenspace uniqueness (classical, here reused).

---

## 8. Lean architecture reusing Mathlib and the supplied declarations

Do **not** bake `4×4` matrices into the main theorem. Layering:

```
Layer A (abstract, Mathlib-native)
  • CarrierDatum over `[Ring R] [StarRing R]`  (reuse `StarRing`, `IsSelfAdjoint`)
  • parity via `Γ`-conjugation; reuse CarrierRigidity.{evenPart,oddPart,
    parity_decomposition_unique, square_oddPart, square_evenPart}
  • selector = grading operator: reuse
        NullEdgeCloser.blocks_eq_eigenspaces / decomposition_unique
    and its packaging commuting_involutions_decomposition_unique (this report)
  • moduli: `Ref(S)` as an `AddTorsor H _`  (reuse Mathlib `AddTorsor`,
    `Submodule`, `DirectSum.IsInternal`, `Module.End.eigenspace`)

Layer B (concrete witnesses, quarantined)
  • CarrierRigidity.Concrete  (non-rigidity witness)
  • UnifiedMassBudget         (explicit even channels; used ONLY as a witness
                               instance of Layer A, never as the theorem)
  • FourChannelRigidity       (coefficient recovery) — RETARGET IMPORTS FIRST

Main theorems (Layer A) take a `CarrierDatum` + selector hypotheses; the matrices
appear only when *instantiating* the abstract theorem to produce examples.
```

Concretely: the main `even_split_unique_iff_separating_grades` and
`residual_moduli_no_go` are stated over an abstract `CarrierDatum`; `Concrete` and
`UnifiedMassBudget` are supplied to the existence/no-go horns as *instances*. The
already-checked `commuting_involutions_decomposition_unique` shows the abstract
core needs no matrices. This is exactly the reuse the brief asks for and is what
`ChannelClassificationReview.lean` demonstrates (it consumes
`NullEdgeCloser.decomposition_unique` and `UnifiedMassBudget.*` without adding any
new matrix into the abstract statement).

---

## 9. Audit of `exhaustive`, `four channel types are forced`, `unique`, `canonical`

Safe replacements, per retained-data level:

| Phrase (unsafe) | Retained data | Safe replacement |
|---|---|---|
| "**exhaustive** word-source expansion" | grouping of monomials | "the chosen grouping accounts for every monomial; the grouping is a **definition**, so 'no fifth term' is a bookkeeping identity, not a rigidity theorem" |
| "the **four channel types are forced**" | `(Γ,#)` only | "chirality forces the **odd/even (two-block)** split (`parity_decomposition_unique`); the three even channels are **not** forced (`shared_type_but_distinct`)" |
| "the split is **unique**" | `(Γ,#)` only | "**not unique**: the even sector is an `H`-torsor of refinements (dim ≥ 1)" |
| "the split is **unique**" | `(Γ,#)` + distinct-grade operator | "**unique given a separating grading operator** (`decomposition_unique`)" |
| "the split is **unique**" | `(Γ,#)` + support coordinates | "**determined once the support/coordinate selectors are fixed** — note this presupposes the answer's support (`FourChannelRigidity`, circular reading)" |
| "**canonical** four-channel decomposition" | any | "canonical **odd/even** split; the four-channel refinement is canonical **relative to a chosen locality/degree/edge structure**, not intrinsically" |

At every level: name the retained structure in the same sentence as the strength
word. "Unique/canonical" is licensed **only** with an explicit separating grade.

---

## 10. Ranked 6-hour theorem sequence and paper verdict

**Ranked sequence (highest value first):**

1. **(0.5h) Retarget `FourChannelRigidityCapstone.lean` imports** so it elaborates
   in this project; re-pin axioms. Restores "kernel-checked" status of the
   coefficient-recovery witness. *(Prerequisite for any honesty claim.)*
2. **(1h) Formalize `Ref(S)` as an `AddTorsor H` and upgrade
   `even_sector_moduli_nontrivial` to the torsor statement** (§2). Turns the
   1-parameter witness into "the moduli *is* the affine space `H`."
3. **(1h) Generalize `commuting_involutions_decomposition_unique` to three grades
   `Fin 3` / `Bool³`** and instantiate `Γ ⊕ E ⊕ N` (§4, §6 `⇐`). Gives the
   sufficiency half of the N&S theorem.
4. **(1.5h) Prove the `⇒` half via `shared_type_but_distinct`** to complete
   `even_split_unique_iff_separating_grades` (§6). This is the publishable core.
5. **(1h) State and prove `residual_moduli_no_go`** under the "all commuting
   intrinsic operators act as scalars on the even sector" hypothesis (§6). The
   sharp negative theorem.
6. **(1h) One second inequivalent nondegenerate carrier + one equivalence control**
   (§F3): a carrier where a *locality* grading exists and collapses `Ref`, beside
   the `Concrete` carrier where it does not — exhibiting both horns of the N&S
   theorem on explicit data.

**Explicit family + control (already delivered, checked):** the F1 family
(`even_sector_moduli_nontrivial`) is the nondegenerate case; the F2 corollary
(`commuting_involutions_decomposition_unique`) is the uniqueness/control case.

**Paper verdict: `SECTION OF PAPER F`.**

Rationale. The package contains one genuinely reusable positive theorem
(`decomposition_unique`), one sharp negative witness (`shared_type_but_distinct`),
and the correct canonical two-block split (`parity_*`). That is a complete,
honest **boundary section**: "chirality fixes the odd/even split; the even-sector
refinement is a nontrivial moduli that a separating locality/degree grade — and
only such a grade — collapses." It is **not yet `STANDALONE CLASSIFICATION`**
because (i) the moduli is currently *witnessed* (dim ≥ 1) rather than *classified*
(dim `H` computed for a carrier class), (ii) no *intrinsic* second selector
exists, so the N&S theorem's `⇐` presently imports the selector as hypothesis, and
(iii) the physical/information selectors are not yet compared on one carrier. It is
**well past `NOT YET A PAPER`**: the objects, one selector theorem, an explicit
nondegenerate family, and a boundary control are all present and (for F1/F2)
kernel-checked. Completing steps 2–5 above upgrades it to a standalone
classification.

---

## Prohibited weakenings

- Do **not** restate `square_decomposition` as evidence of rigidity: it is a
  definitional regrouping (does not even use nullness/anticommutation).
- Do **not** define any channel as `True`, as the zero operator, or behind a
  never-satisfiable hypothesis to make a uniqueness statement vacuously hold.
- Do **not** let the fitted constant `c = 1184/75` enter a theorem *statement* as
  if the Frobenius budget were derived from `det P`.
- Do **not** upgrade "unique/canonical" without naming the separating grade in the
  same statement (§9).
- Do **not** conflate the three different carriers/normalizations (`CarrierRigidity`
  `2·`, manuscript `4·`, `UnifiedMassBudget` `(1,1,1,1)`) as one result.

## Circular selectors (must be excluded from carrier data)

- **Support/coordinate readers** `readA, readC, readT, readE` — they normalize by
  the target channel's own entry, i.e. they *are* the answer's support pattern.
  Linear independence "recovered" from them is disjoint-support bookkeeping, not
  canonicity.
- **Hand-placed channel supports** (`QA=diag(8,0,0,0)`, `QC`, `QT`, `Es`) used as
  the *definition* of the channels rather than as a *witness instance* of an
  abstract split.
- Any "edge-exchange" or "solder-degree" operator asserted to be intrinsic without
  a proof that it is `(Γ,#)`-definable and commutes with `Γ` (§4 flags).

---

## Theorem dependency DAG (honest)

```
                 [Γ²=1, star Γ=Γ, star φ=φ]
                             │
                 square_decomposition            (definitional regrouping)
                    │            │
        aperture/closure/turn/solder_selfadjoint
                    │
   {aperture,closure,turn}_even   solder_odd     (uses {Γ,c}=0, [Γ,g]=0)
                    │                 │
                    ▼                 ▼
       square_evenPart          square_oddPart   ◄─ parity_decomposition_unique
        (even = A+C+2T)         (odd = 2E_#)          (2 invertible)
                    │
        ┌───────────┴─────────────────────────────┐
        ▼                                          ▼
 Concrete.shared_type_but_distinct        even_sector_moduli_nontrivial   [F1, checked]
 (no intrinsic 2nd separator)             (Ref torsor, dim ≥ 1)
        │                                          │
        └──────────────┬───────────────────────────┘
                       ▼
        even_split_unique_iff_separating_grades     [target §6]
             ▲                       │ (⇐)
             │(⇐ generalizes)        ▼
 commuting_involutions_decomposition_unique  [F2, checked]
             ▲
             │ reduction D = P + 2Q, distinct grades
 NullEdgeCloser.decomposition_unique ◄─ blocks_eq_eigenspaces
                       │
                       ▼
             residual_moduli_no_go            [target §6, no-go]

  (independent illustration, not on the critical path)
     NullEdgeCloser.split_not_forced   — generic ℝ² complements
  (concrete numerics, witness layer only)
     UnifiedMassBudget.* ; FourChannelRigidity.*  (retarget imports first)
```

## Honest publication headline

> **In a finite Krein–Dirac carrier, chirality canonically fixes the odd/even
> (soldering vs. bulk) split, but the even sector's refinement into
> aperture/closure/turn is an affine moduli space (an `H`-torsor of dimension
> ≥ 1) that no chirality-and-adjoint–intrinsic datum separates; a commuting
> locality/solder-degree grading with distinct joint spectrum is necessary and
> sufficient to collapse it, and absent such a grading the residual moduli is
> exactly `H`.**

The four physical names (kinetic/QCD/Yukawa/gravity) stay out of every theorem
statement and enter only after this representation-independent characterization —
as the program's own target-audience note already requires.

*(Companion machine-checked file: `ChannelClassificationReview.lean` — F1 family
and F2 commuting-involution uniqueness, axioms `[propext, Classical.choice,
Quot.sound]`, zero `sorry`.)*
