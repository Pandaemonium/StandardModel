# Null-edge ↔ Furey internal-spectrum bridge

**Wave 6 strategy / formal-interface job. No-build.**
Date: 2026-06-26.

Purpose: decide whether the repo's Furey / division-algebra Standard Model work
(one-generation anomaly cancellation, Furey-to-one-generation bridge packages,
electroweak anomaly bridge, anomaly decomposition) can be promoted into a clean
**internal-spectrum layer** for the null-edge mass program: a typed interface
that feeds the zero-order block `Phi_H` and lets local + Witten anomaly freedom
be *inherited* rather than re-derived.

Companion conventions:
[`../materials/CONVENTIONS.md`](../materials/CONVENTIONS.md),
[`../materials/Null_Edge_Unified_Mass_Model_Working_Plan.md`](../materials/Null_Edge_Unified_Mass_Model_Working_Plan.md).

Anchor file (already verified clean, axiom-clean, sorry-free):
`PhysicsSM/Draft/StandardModelAnomalyAudit.lean` (job `S15`).
Adjacent draft files referenced below:
`PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean` (job `S1`),
`PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean` (job `S2`),
`PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` (job `A1`).

---

## 0. Load-bearing guardrails (carry on every promotion)

These travel with every theorem and instance produced from this note. They are
not optional framing; they bound what the bridge is allowed to claim.

- **Furey supplies the internal spectrum and anomaly consistency, not mass.**
  The bridge fixes *which* representations exist and that their charge sums
  cancel. It does **not** supply the Yukawa matrix `M`, hence does not supply
  `Phi_H`, hence does not supply any fermion mass. `M` (and thus `Phi_H`)
  remains free input at this layer.
- **Do not collapse anomaly cancellation into a mass theorem.** Anomaly freedom
  is a representation/charge-bookkeeping fact. `Phi_H^2` is a separate,
  zero-order operator block. No lemma may chain "anomaly-free" to "massive".
- **Preserve the all-left Weyl convention.** Every multiplet is recorded as a
  left-handed Weyl field; right-handed fields appear as their left-handed charge
  conjugates **with the hypercharge sign flipped** (`u_R^c`, `d_R^c`, `e_R^c`).
  Never silently switch a stored entry back to a right-handed field; the L/R
  split used by `Phi_H` is a *different* basis (§3.2), related by charge
  conjugation, and must be named separately.
- **Keep QCD / confinement out of the bridge.** `SU(3)` enters only as a vector-
  like colour multiplicity in the charge bookkeeping. No `B_QCD`, no
  confinement, no proton mass. A single boundary note (§7) is allowed.

---

## 1. Task 1 — the `NullEdgeInternalSpectrum` interface

### 1.1 Base data: chiral multiplets and the one-generation list

This reuses the representation already proved correct in
`StandardModelAnomalyAudit.lean`: the one-generation spectrum is a list of
left-handed Weyl multiplets carrying `(colour, weak, Y)` with `mult = colour *
weak` and the convention `Q = T₃ + Y/2`. The interface should re-export exactly
this datatype so the bridge equality is between *the same* object the anomaly
audit already reasons about.

```lean
/-- A left-handed Weyl chiral multiplet:
`colour` = SU(3) multiplicity, `weak` = SU(2) multiplicity, `Y` = weak
hypercharge in the convention `Q = T₃ + Y/2`.

All-left convention: right-handed Standard Model fields are stored as their
left-handed charge conjugates with the hypercharge sign flipped. -/
structure ChiralMultiplet where
  colour : ℕ
  weak   : ℕ
  Y      : ℚ
deriving DecidableEq, Repr

/-- Number of Weyl components in a multiplet. -/
def ChiralMultiplet.mult (m : ChiralMultiplet) : ℕ := m.colour * m.weak

/-- One generation, all-left:
`Q_L(3,2,1/6)`, `L_L(1,2,-1/2)`, `u_R^c(3,1,-2/3)`, `d_R^c(3,1,1/3)`,
`e_R^c(1,1,1)`.  Matches `StandardModelAnomalyAudit.lean`. -/
def standardModelOneGeneration : List ChiralMultiplet :=
  [ ⟨3, 2,  1/6⟩,
    ⟨1, 2, -1/2⟩,
    ⟨3, 1, -2/3⟩,
    ⟨3, 1,  1/3⟩,
    ⟨1, 1,  1⟩ ]

/-- Optional right-handed neutrino conjugate `ν_R^c(1,1,0)`. -/
def standardModelOneGenerationWithNu : List ChiralMultiplet :=
  standardModelOneGeneration ++ [⟨1, 1, 0⟩]
```

### 1.2 The interface

`NullEdgeInternalSpectrum` abstracts *whatever* finite internal construction the
null-edge program plugs in (Furey octonionic module, an explicit `ZMod`-indexed
basis, a future alternative). It carries the finite internal index set, the
internal `χ_E` grading that the super-Dirac operator needs, the charge
assignments, and a projection `toChiralMultipletList` to the base datatype.

```lean
/-- An internal-spectrum realization for one generation.

This is the swappable layer that sits under `Phi_H`.  It records:
- a finite index set of internal basis states,
- the internal Z₂ grading `χ_E` (the two Weyl sheets `Phi_H` flips),
- the SU(3)/SU(2)/U(1)_Y charge data,
- a projection to the all-left chiral multiplet list.

It deliberately does **not** record any Yukawa/mass data: mass lives in
`Phi_H` (§3), which is built *on top of* a spectrum, not inside it. -/
structure NullEdgeInternalSpectrum where
  /-- Finite index set of internal basis states. -/
  States : Type
  [statesFintype  : Fintype States]
  [statesDecEq    : DecidableEq States]
  /-- Internal grading χ_E ∈ {+1,-1}, the two Weyl sheets. -/
  internalGrading : States → ℤ
  internalGrading_mem : ∀ s, internalGrading s = 1 ∨ internalGrading s = -1
  /-- Projection to the all-left chiral multiplet list (anomaly bookkeeping). -/
  toChiralMultipletList : List ChiralMultiplet

/-- The bridge predicate: an internal spectrum *realizes* one generation when
its multiplet list agrees with `standardModelOneGeneration` **as a multiset**
(order-free).  Permutation, not list equality, is the right notion: the Furey
basis order is arbitrary. -/
def NullEdgeInternalSpectrum.RealizesStandardModel
    (S : NullEdgeInternalSpectrum) : Prop :=
  S.toChiralMultipletList.Perm standardModelOneGeneration
```

Design notes:

- `toChiralMultipletList` is a *field*, not a computed function, because the
  abstraction must allow each realization to enumerate its own basis and read
  off charges its own way. The content of the bridge is the **theorem**
  `RealizesStandardModel`, which pins that field to the SM list.
- `Perm` (multiset equality) is used so the realization theorem is stable under
  the arbitrary internal basis order. Where strict list equality is genuinely
  available (a canonical enumeration), prove the stronger
  `S.toChiralMultipletList = standardModelOneGeneration` and derive `Perm` from
  `List.Perm.refl`.
- `internalGrading` is the **internal** grading `χ_E`, kept strictly separate
  from spacetime chirality `Gamma_s` and form-degree `epsilon_form`
  (CONVENTIONS "Gradings" rule). It is the data `Phi_H` needs in §3 and is the
  hook for the still-missing chiral-realization theorem in §5.

---

## 2. Task 2 — instantiating from the existing Furey bridge theorems

The existing Furey-to-one-generation bridge package + electroweak anomaly
bridge + anomaly decomposition already produce, from a division-algebra internal
module, the decomposition into exactly the five (or six) SM multiplets with the
correct hypercharges. That is *precisely* the content needed to build an
instance and prove `RealizesStandardModel`.

```lean
/-- Instance built from the Furey division-algebra internal module.

`States` is the Furey basis index; `internalGrading` is the algebraic
left/right grading the bridge already supplies; `toChiralMultipletList` reads off
the multiplet charges produced by the anomaly-decomposition theorem. -/
noncomputable def fureyInternalSpectrum : NullEdgeInternalSpectrum where
  States                := FureyBasis            -- existing index type
  internalGrading       := fureyChi_E           -- existing algebraic grading
  internalGrading_mem   := fureyChi_E_pm        -- existing ±1 lemma
  toChiralMultipletList := fureyMultiplets      -- existing charge read-off

/-- The Furey bridge theorem, restated as interface realization.

This is *exactly* the existing one-generation bridge / electroweak anomaly
bridge content, re-exposed through the interface.  It says: the Furey internal
module decomposes into the all-left SM one-generation spectrum. -/
theorem furey_realizes_standardModel :
    fureyInternalSpectrum.RealizesStandardModel := by
  -- `unfold RealizesStandardModel fureyInternalSpectrum`,
  -- then apply the existing Furey→one-generation decomposition theorem
  -- (the charge list agrees up to permutation).
  sorry
```

What this instance does and does **not** establish:

- **Does:** the Furey module *contains exactly* the SM one-generation
  representations, with the correct hypercharges, in the all-left convention.
  Combined with §4, this makes the Furey realization anomaly-free *by
  inheritance*, with no new anomaly arithmetic.
- **Does not:** explain mass. `fureyInternalSpectrum` has no `M`, no `Phi_H`, no
  spectral gap. Furey fixes the *spectrum and its anomaly consistency*; the
  chirality-flip block `M` that turns a spectrum into masses is supplied
  separately in §3 and is unconstrained by anything in this section.
- The instance is `noncomputable` only if `FureyBasis`/`fureyChi_E` are; if the
  bridge package exposes a concrete enumeration, drop `noncomputable` and prove
  the stronger list-equality form.

---

## 3. Task 3 — connecting the interface to `Phi_H`

### 3.1 What `Phi_H` acts on

From the Working Plan (§4.2, §6.1, §15.5) the zero-order block is

```text
D = i D_N + Gamma_s Phi_H,    Phi_H = [[0, M†], [M, 0]],   M : E_R → E_L.
```

`Phi_H` acts on the **physical Dirac internal space** `V = E_L ⊕ E_R`, where
`E_L`, `E_R` are the left/right internal flavor spaces. These are obtained from a
`NullEdgeInternalSpectrum` by **splitting along `internalGrading = χ_E`**:

```lean
/-- Left/right internal subspaces carved out by the internal grading. -/
def NullEdgeInternalSpectrum.LeftStates  (S : NullEdgeInternalSpectrum) :=
  {s : S.States // S.internalGrading s = 1}
def NullEdgeInternalSpectrum.RightStates (S : NullEdgeInternalSpectrum) :=
  {s : S.States // S.internalGrading s = -1}
```

`Phi_H` is then the off-diagonal operator on
`(LeftStates →₀ ℂ) ⊕ (RightStates →₀ ℂ)` with blocks `M : E_R → E_L` and
`M† : E_L → E_R`. The eigen-data is the existing checkerboard identity:

```text
Phi_H^2 = [[M† M, 0], [0, M M†]],   spec(M† M) = squared fermion masses.
```

### 3.2 The two-basis caveat (preserves the all-left convention)

There are **two distinct internal bases**, and the bridge must keep them apart:

1. **All-left anomaly basis** (`toChiralMultipletList`): every field, including
   right-handed ones, stored as a left-handed Weyl conjugate with flipped
   hypercharge. This is the *only* basis used for §4 (anomaly bookkeeping).
2. **Physical Dirac basis** (`E_L ⊕ E_R`): the L/R split `Phi_H` flips, given by
   `internalGrading`. Right-handed fields appear here as genuine right-handed
   fields.

The two are related by charge conjugation `C`: undoing the conjugation that
defines the all-left entries `u_R^c, d_R^c, e_R^c` returns the right-handed
fields that populate `E_R`. **Do not use one basis where the other is required.**
Anomaly sums are all-left; `Phi_H`/`M` are Dirac-basis. Conflating them is the
classic way to flip a hypercharge sign or double-count a field.

### 3.3 Chirality / handedness conventions needed

From CONVENTIONS ("Super-Dirac square signs", "Gradings") and Working Plan
§15.5, the data `Phi_H` must satisfy:

- **`[Gamma_s, Phi_H] = 0`** — `Phi_H` commutes with *spacetime* chirality.
  This is what gives the `+Phi_H^2` sign in `D^2` (the locked convention). If
  instead `{Gamma_s, Phi_H} = 0`, the sign flips to `-Phi_H^2`.
- **`Phi_H` odd under `χ_E`** — off-diagonal in the `internalGrading` split
  (`E_L ↔ E_R`), which is exactly the block form above.
- **Keep `Gamma_s`, `χ_E`, `epsilon_form` separate** — never repair a spacetime
  chirality sign with the internal or form grading.

### 3.4 Which existing Yukawa-flip proofs can be reused

- **`NullEdgeYukawaCheckerboard.lean` (S1).** Supplies `Phi_H^2 = diag(M† M,
  M M†)` and the chirality-flip gap / rectangular singular-value statement. This
  is the operator core of `Phi_H` over `E_L ⊕ E_R` and is reused verbatim once
  `E_L, E_R` are produced from `internalGrading`.
- **`NullEdgeSuperDiracSignAudit.lean` (A1, Gate A).** Supplies the
  `+Phi_H^2` vs `-Phi_H^2` sign theorem from the `[Gamma_s, Phi_H]=0` vs
  `{Gamma_s, Phi_H}=0` hypotheses. Reused to certify the §3.3 commutation
  requirement.
- **`NullEdgeElectroweakStabilizer.lean` (S2).** Independent: it lives on the
  *gauge-boson* side (`B_EW(X) = X H_0`, `ker = u(1)_em`, `rank = 3`). It is
  **not** part of `Phi_H` (fermion block) — included here only to mark the
  boundary: W/Z mass is not a chirality flip and must not enter `Phi_H^2`
  (CONVENTIONS "Fermion mass versus W/Z mass").

`Phi_H` is therefore assembled as: *internal spectrum from §1/§2* → *L/R split
via `χ_E`* → *checkerboard block `M` from S1* → *sign certified by A1*. The
spectrum layer is anomaly-bearing; the `M` is free input; nothing in §3 derives
`M` from §2.

---

## 4. Task 4 — the anomaly inheritance theorem

Define the four hypercharge-dependent anomaly functionals and the Witten parity
as functions of a `List ChiralMultiplet`, matching the sums proved in
`StandardModelAnomalyAudit.lean`:

```lean
/-- U(1)-gravitational anomaly  Σ mult·Y. -/
def gravAnomaly (l : List ChiralMultiplet) : ℚ :=
  (l.map (fun m => (m.mult : ℚ) * m.Y)).sum
/-- U(1)³ anomaly  Σ mult·Y³. -/
def cubeAnomaly (l : List ChiralMultiplet) : ℚ :=
  (l.map (fun m => (m.mult : ℚ) * m.Y ^ 3)).sum
/-- SU(2)²U(1) anomaly  Σ_{weak doublets} colour·Y. -/
def su2Anomaly (l : List ChiralMultiplet) : ℚ :=
  ((l.filter (fun m => m.weak = 2)).map (fun m => (m.colour : ℚ) * m.Y)).sum
/-- SU(3)²U(1) anomaly  Σ_{colour triplets} weak·Y. -/
def su3Anomaly (l : List ChiralMultiplet) : ℚ :=
  ((l.filter (fun m => m.colour = 3)).map (fun m => (m.weak : ℚ) * m.Y)).sum
/-- Witten SU(2) global anomaly counter: number of SU(2) doublets. -/
def wittenDoubletCount (l : List ChiralMultiplet) : ℕ :=
  ((l.filter (fun m => m.weak = 2)).map (fun m => m.colour)).sum
```

These are all **permutation-invariant** (each is `sum` of a `map`, optionally
after a `filter`, and both `List.Perm.map`/`List.Perm.filter` preserve `Perm`,
after which `List.Perm.sum_eq` applies). The base facts (already in
`StandardModelAnomalyAudit.lean`, re-validated numerically here) are:

```text
gravAnomaly  standardModelOneGeneration = 0
cubeAnomaly  standardModelOneGeneration = 0
su2Anomaly   standardModelOneGeneration = 0
su3Anomaly   standardModelOneGeneration = 0
Even (wittenDoubletCount standardModelOneGeneration)   -- count = 4
```

(All five verified by `#eval`; the rationals discharge by `simp; norm_num`, the
parity by `decide`.) The inheritance theorem then reads:

```lean
/-- Local (perturbative) anomaly freedom is inherited by any null-edge internal
spectrum that realizes one generation. -/
theorem anomaly_inheritance_local
    (S : NullEdgeInternalSpectrum) (h : S.RealizesStandardModel) :
    gravAnomaly S.toChiralMultipletList = 0 ∧
    cubeAnomaly S.toChiralMultipletList = 0 ∧
    su2Anomaly  S.toChiralMultipletList = 0 ∧
    su3Anomaly  S.toChiralMultipletList = 0 := by
  -- rewrite each functional along `h : Perm`, then close with the
  -- StandardModelAnomalyAudit facts.
  sorry

/-- Witten SU(2) global anomaly freedom is inherited as well. -/
theorem anomaly_inheritance_witten
    (S : NullEdgeInternalSpectrum) (h : S.RealizesStandardModel) :
    Even (wittenDoubletCount S.toChiralMultipletList) := by
  sorry
```

Permutation-invariance lemmas (the reusable engine of the inheritance proof):

```lean
theorem gravAnomaly_perm {l₁ l₂} (h : l₁.Perm l₂) :
    gravAnomaly l₁ = gravAnomaly l₂ := (h.map _).sum_eq
-- analogous for cube / su2 / su3 (filter first) and wittenDoubletCount.
```

(`gravAnomaly_perm` is verified to compile via `(h.map _).sum_eq`.) Specializing
`fureyInternalSpectrum` with `furey_realizes_standardModel` then yields Furey
anomaly freedom with **zero** new arithmetic — the desired "inheritance".

**Scope disclaimer (must travel with these theorems):** this is representation /
charge bookkeeping only. It shows the charge sums vanish for any spectrum whose
multiplet *multiset* is the SM one. It does **not** show the null-edge
construction realizes the *chiral* SM (next section).

---

## 5. Task 5 — the missing theorem (chiral realization vs. table reuse)

`anomaly_inheritance_*` only compares **unsigned charge bookkeeping**. A spectrum
could match `standardModelOneGeneration` as a multiset of charges yet be
*vector-like* (every left-handed multiplet paired by a mirror right-handed
partner of the same charge), in which case it carries no net chirality and is
physically not the SM. Anomaly freedom is then trivial and uninformative.

The missing object is a **chiral realization theorem**: a statement that the
null-edge Dirac operator on the internal space produces the SM one-generation
content *as a signed (chiral) representation*, with no mirror doubling.

```lean
/-- Signed multiplet content: each multiplet weighted by its net chirality
(`internalGrading` summed over the states forming it), i.e. (#left − #right). -/
def NullEdgeInternalSpectrum.netChiralContent
    (S : NullEdgeInternalSpectrum) : ChiralMultiplet → ℤ := sorry

/-- MISSING THEOREM (chiral realization).

The null-edge internal Dirac data realizes the chiral Standard Model:
the net chirality (left minus mirror-right) of each charge sector equals the
all-left SM assignment, AND there is no fermion doubling (no charge-neutral
mirror pair cancels in `netChiralContent`).

Equivalently, an index/no-doubling statement:
  netChiralContent S = (the SM all-left content, each multiplet with weight +1)
and the flat retarded symbol of `D_N` on the internal space has the correct
determinant-level branch count (no Nielsen–Ninomiya mirror modes). -/
theorem chiral_realization
    (S : NullEdgeInternalSpectrum) (h : S.RealizesStandardModel)
    (hChiral : /- genuine internal chirality hypothesis, TBD -/ True) :
    (∀ m ∈ standardModelOneGeneration, S.netChiralContent m = 1) ∧
    /- no-doubling / branch-count clause -/ True := by
  sorry
```

Why this is the real gate:

- It is the difference between "we re-used the SM anomaly table" (have:
  §4) and "the null-edge model *is* chiral SM" (want).
- It requires a genuine chiral mechanism (CONVENTIONS "Still not fully locked":
  internal chiral representation / domain wall / overlap / Krein imbalance), and
  must clear the **determinant-level branch-count / no-doubling** rule
  (CONVENTIONS "Branch-count / no-doubling test") — coefficient-vector zeros do
  **not** suffice.
- It is the one place where `internalGrading` (`χ_E`) must do real work rather
  than just bookkeeping. Furey can *propose* `χ_E`; whether it survives the
  no-doubling audit is open.

Until `chiral_realization` exists, the honest claim ceiling is: *"the null-edge
internal spectrum reproduces the SM one-generation charge content and inherits
local + Witten anomaly freedom"* — never *"realizes the chiral SM"*.

---

## 6. Task 6 — status of Furey in the program

**Recommendation: preferred (but optional) internal realization. Not a core
axiom.**

Rationale:

- **Optional, structurally.** Every theorem in §3–§4 depends only on the
  abstract `NullEdgeInternalSpectrum` interface and on `RealizesStandardModel`.
  None mentions octonions or division algebras. The mass program must not be
  hostage to one algebraic construction; the interface keeps it swappable
  (an explicit `ZMod`-indexed spectrum could discharge the same obligations).
- **Preferred, scientifically.** Furey is the most economical and well-motivated
  way to *produce* the spectrum and its anomaly consistency from first
  principles rather than postulating the charge table. It earns the canonical
  instance `fureyInternalSpectrum` and should be the default `RealizesStandardModel`
  witness.
- **Not a core axiom.** Promoting Furey to an axiom would (a) import its open
  problems — three-generation structure, uniqueness of the algebra, the chiral
  realization of §5 — into the *foundations* of the mass program, and (b)
  violate the no-axiom hygiene of the repo. Furey's role is to *instantiate* an
  interface and *discharge* `RealizesStandardModel`, not to be assumed.

Net: treat Furey as the **preferred internal realization** wired in through the
interface, with the interface itself as the load-bearing abstraction.

---

## 7. Boundary note (QCD / confinement — out of scope)

`SU(3)` appears in this bridge only as a vector-like colour multiplicity inside
the charge bookkeeping (`colour` field; `su3Anomaly` cancels because QCD is
vector-like). The bridge says nothing about confinement, the color-holonomy
gap, or proton mass, and defines no `B_QCD`. Safe sentence (CONVENTIONS): *"QCD
supplies confinement and dynamics; the null-edge spectrum supplies invariant
charge accounting."* Any finite `B_QCD` is a separate future gate.

---

## 8. Task 7 — follow-up Aristotle jobs

| ID | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- |
| F1 | **Proof** | Build `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean`: the `ChiralMultiplet` re-export, `NullEdgeInternalSpectrum`, `RealizesStandardModel`, the five anomaly functionals, the `*_perm` invariance lemmas, and **prove `anomaly_inheritance_local` + `anomaly_inheritance_witten`** against `StandardModelAnomalyAudit.lean`. | Turns "inherits anomaly freedom" from prose into a kernel-checked theorem; gives the swappable interface a sorry-free spine. | `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` |
| F2 | Proof | Instantiate `fureyInternalSpectrum` from the existing Furey→one-generation bridge package and prove `furey_realizes_standardModel`. Keep `M`/`Phi_H` absent (guardrail check). | Makes the Furey realization formal and confirms it supplies spectrum+anomaly, not mass. | `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean` |
| F3 | Proof | Wire `Phi_H` over `E_L ⊕ E_R` from `internalGrading`, reusing the S1 checkerboard square and the A1 sign audit; prove `Phi_H^2 = diag(M†M, MM†)` and `[Gamma_s, Phi_H] = 0 ⇒ +Phi_H^2`. | Connects the spectrum layer to the zero-order mass block without re-deriving the Yukawa square. | `PhysicsSM/Draft/NullEdgePhiHFromSpectrum.lean` |
| F4 | Audit | Two-basis audit: prove (or counterexample) that the all-left anomaly basis and the physical `E_L ⊕ E_R` Dirac basis are related by a charge conjugation that flips exactly the conjugate-field hypercharges; flag any sign-flip drift. | Protects the all-left convention + hypercharge sign flips against silent basis-conflation. | `AgentTasks/null-edge-internal-spectrum-two-basis-audit.md` |
| F5 | Proof / Strategy | Formalize the §5 **`chiral_realization`** target: define `netChiralContent`, state the no-doubling (determinant branch-count) clause, and either prove it for a chiral candidate or produce a vector-like counterexample with matching charge multiset. | This is the gate separating "reused the SM table" from "realizes chiral SM"; highest-value open theorem of the bridge. | `PhysicsSM/Draft/NullEdgeChiralRealization.lean` + `AgentTasks/null-edge-chiral-realization-gate.md` |

---

## 9. Summary

- **Interface (Task 1):** `NullEdgeInternalSpectrum` with field `toChiralMultipletList`
  and predicate `RealizesStandardModel := toChiralMultipletList.Perm standardModelOneGeneration`,
  reusing the exact `ChiralMultiplet` datatype of `StandardModelAnomalyAudit.lean`.
- **Furey instance (Task 2):** the existing bridge theorems give
  `fureyInternalSpectrum` and `furey_realizes_standardModel` — spectrum + anomaly
  consistency, **no mass**.
- **`Phi_H` (Task 3):** acts on `E_L ⊕ E_R` carved by `χ_E`; needs
  `[Gamma_s, Phi_H]=0`, `Phi_H` odd under `χ_E`, gradings kept separate; reuses
  the S1 checkerboard square and A1 sign audit; two-basis caveat preserves the
  all-left convention and conjugate hypercharge sign flips.
- **Anomaly inheritance (Task 4):** four perm-invariant functionals + Witten
  parity, all vanishing on the SM list (numerically verified), give
  `anomaly_inheritance_local` / `anomaly_inheritance_witten` by inheritance.
- **Missing theorem (Task 5):** `chiral_realization` (signed net-chirality +
  determinant-level no-doubling) — the gate to "realizes chiral SM".
- **Furey status (Task 6):** preferred but optional internal realization, not a
  core axiom.
- **QCD (§7):** boundary note only.
- **Follow-ups (Task 7):** F1–F5, with F1/F2/F3/F5 as Lean proof targets.
