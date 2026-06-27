# Null-edge QCD obstruction-map scoping audit

**No-build strategy/audit deliverable. Generated 2026-06-26.**

Scope and method. This is a written scoping report only. No Lean, Lake,
pre-commit, or build/check command was run. It synthesizes the program's own
source and convention documents:

- `docs/CONVENTIONS.md` (QCD/hadron-mass boundary rule; canonical
  obstruction-datum definition; claim-label discipline);
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Sections 17-20
  (especially 17.8, 20.2, 20.10, 20.12);
- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md`
  (Sections C.8 and D.2, the QCD blocker discussion).

Core question addressed. Can the null-edge mass program responsibly define any
near-term finite `B_QCD`, or should QCD remain strictly boundary/motivation
until a finite color Hamiltonian or holonomy gap theorem is available?

**Verdict (one line).** No near-term finite `B_QCD` should be defined. QCD must
stay strictly boundary/motivation, and no QCD-related Aristotle proof job should
enter the theorem waves yet. The only honest near-term QCD deliverables are the
fixed boundary sentence, the trace-anomaly/spectrum disclaimer, and (optionally)
a sharply-scoped abstract toy lemma that is explicitly *not* called `B_QCD` and
explicitly does *not* mention QCD, color, confinement, or hadrons in its claim.

---

## 1. The safe boundary claim (restated and frozen)

The convention-locked boundary sentence, to be used verbatim wherever the
program touches QCD:

```text
QCD supplies confinement and dynamics; Plucker supplies invariant accounting.
```

Unpacked into the two-line form used in Working Plan 4.4:

```text
QCD explains why the relativistic/null constituents are confined.
The Plucker theorem gives the finite kinematic invariant of the confined
bundle.
```

What this sentence does and does not assert:

- It asserts only that the finite Plucker identity
  `det(sum_i psi_i psi_i^dagger) = sum_{i<j} |psi_i wedge psi_j|^2`
  is the *kinematic accounting* invariant any null/relativistic constituent
  description must reproduce once a confined momentum distribution is supplied.
- It does **not** assert that the Plucker theorem derives the proton mass, the
  hadron spectrum, the QCD scale, or the trace anomaly. Those remain dynamics
  that the accounting takes as input.

This matches the locked rule in `docs/CONVENTIONS.md` ("QCD and hadron mass":
boundary rule locked, theorem content unlocked) and Working Plan 20.10.

---

## 2. What a genuine finite `B_QCD` obstruction map would require

Per the locked canonical-obstruction-datum definition (`docs/CONVENTIONS.md`;
Working Plan 20.2), a legitimate obstruction map is a pair `(S, B)` where `S` is
a finite geometric/internal structure and

```text
B : configuration space(S) -> failure space(S)
```

is functorial/natural in `S`, determined by `S` rather than by fitted masses,
with `ker B` the massless/gapless/symmetric locus and `B^dagger B` the quadratic
obstruction away from it. For `B_QCD` to clear this bar, **all** of the following
would have to be in hand, not assumed by analogy:

1. **A finite color structure `S`.** An explicit finite graph / finite-
   dimensional color configuration space with stated boundary conditions, gauge
   group `SU(3)_c` content, and a color-singlet subspace identified canonically
   (not chosen to fit a target).

2. **A canonical map `B_QCD` determined by `S`.** Either
   - a finite color Hamiltonian `H_color^finite` whose construction is forced by
     the finite color structure and boundary data; or
   - a finite color-holonomy obstruction whose `ker` is exactly the gauge-
     singlet / unobstructed locus.
   The map must be natural in `S`, not reverse-engineered from a known mass.

3. **A genuine gap theorem of the locked target shape.** Concretely (Working
   Plan 20.10; `docs/CONVENTIONS.md`):

   ```text
   H_color^finite restricted to singlets >= Delta > 0
   ```

   under explicit finite graph and boundary assumptions, with `Delta` produced
   by the construction rather than inserted by hand.

4. **A non-vacuity / canonicity certificate.** Evidence that `B_QCD` is not just
   "some positive operator written as `B^dagger B`" (any positive matrix is
   such). The map must be geometrically or physically forced by `S`, and the gap
   must not be an artifact of a finite truncation that disappears or rescales
   trivially.

5. **A stable continuum/scaling story (long-horizon).** Some statement that the
   finite gap is not destroyed by the finite-to-continuum limit, or at minimum a
   labelled disclaimer that the result is finite-only. Note this is downstream of
   the program's *master* blocker (the finite-to-continuum symbol/square limit,
   grand-strategy Section C), so even a clean finite `B_QCD` would inherit that
   open dependency.

None of items 1-5 currently exists in the program. Therefore `B_QCD` is "not yet
available" (the locked ledger entry), and defining it now would violate the
canonical-obstruction discipline.

---

## 3. Minimal toy models that are honest but not overclaiming

These are *optional* abstract exercises. If pursued, they must be stated as
finite linear-algebra / finite-graph lemmas with explicit assumptions, and they
must **not** be labelled `B_QCD`, must **not** appear in P1 or P1.5 theorem
claims as QCD results, and must **not** name color, confinement, hadrons, or
`Lambda_QCD` in their conclusions. They are honest only as *templates that show
what shape a future result would take*, never as QCD physics.

### Toy model T1: finite singlet-projection energy gap (abstract)

Data (all finite, all explicit):

```text
V            finite-dimensional inner-product space (the "configuration" space)
P_sing       orthogonal projection onto a distinguished subspace ("singlets")
H            self-adjoint operator on V with H >= 0
assumption   H|_{ker P_sing} = 0  and  H >= Delta * (1 - P_sing-complement) ...
```

Honest target conclusion (one of several equivalent shapes):

```text
There exists Delta > 0 such that for all psi with P_sing psi = 0,
  <psi, H psi> >= Delta * |psi|^2.
```

What it is: a finite spectral-gap statement for a self-adjoint operator relative
to an explicitly distinguished subspace, under assumptions that *put the gap in
by hypothesis*. It is a faithful illustration of the *form* of a future color-
singlet gap, with `ker` = the unobstructed locus and `B^dagger B = H` the
quadratic obstruction.

What makes it honest: the gap is assumed, not derived from any color dynamics.
The lemma proves only that *if* a finite operator has these properties *then* the
singlet-complement is gapped. It demonstrates the obstruction template without
claiming any QCD input.

### Toy model T2: finite color-singlet projection on an explicit small graph (abstract)

Data:

```text
G            an explicit finite graph with stated boundary vertices/edges
W            finite-dimensional "internal" space attached per vertex
Q            a quadratic form on configurations built only from edge differences
             and an explicit projector onto a "neutral"/"singlet" configuration
```

Honest target conclusion:

```text
Q(c) = 0  iff  c lies in the distinguished (singlet/neutral) subspace,
and  Q(c) >= Delta |c|^2  on its orthogonal complement, for an explicitly
computed Delta determined by the graph and boundary data.
```

What it is: a finite, computable graph-quadratic-form gap, structurally parallel
to the Abelian Higgs link-stiffness theorem (Working Plan 17.3 Theorem B) but
with a singlet projector standing in for the vacuum section. The `Delta` is
produced by the finite graph rather than asserted.

What makes it honest: it is pure finite graph linear algebra. It shows that the
*machinery* (config space, distinguished kernel, quadratic obstruction, computed
gap) can be instantiated; it does **not** model `SU(3)_c`, confinement, or any
hadron, and its `Delta` has no relation to `Lambda_QCD`.

### Mandatory naming/labelling guardrails for T1/T2

- Name them with neutral identifiers (for example `finite_singlet_gap`,
  `graph_neutral_obstruction`), never `B_QCD`, `color`, `confinement`.
- Claim label: at most **reconstruction / structural template**, never
  prediction, never "QCD theorem".
- Each must carry a one-line disclaimer: "This is an abstract finite obstruction
  template; it is not a model of QCD and supplies no QCD input."

---

## 4. Why these toy models do not derive QCD physics

Even fully proved, T1 and T2 derive **none** of the following, and the report
recommends saying so explicitly wherever they appear:

- **Proton mass.** The gap `Delta` in T1/T2 is an assumed or graph-computed
  number with no calibration to GeV-scale hadron masses; ~95% of hadron mass is
  confined relativistic field energy (the "mass without mass" picture), which is
  dynamics these finite lemmas never touch. The Plucker identity is the kinematic
  *skeleton* of that picture, not a derivation (grand-strategy D.2).
- **The QCD scale `Lambda_QCD`.** `Lambda_QCD` arises from dimensional
  transmutation in a running coupling. T1/T2 are finite, scale-free, and contain
  no renormalization-group content; their `Delta` is not `Lambda_QCD`.
- **The trace anomaly.** The trace anomaly is an intrinsically continuum,
  quantum, renormalization phenomenon. Finite self-adjoint operators on finite
  spaces cannot exhibit it; the program must explicitly disclaim it (Working
  Plan 16.11, 17.8).
- **The hadron spectrum.** T1/T2 produce a single gap relative to one
  distinguished subspace under chosen assumptions; they generate no tower of
  states, no spin/flavor structure, and no spectral ordering.
- **Confinement / running coupling / color holonomy dynamics.** These are the
  dynamical inputs the boundary sentence assigns to QCD; the toy models assume a
  singlet structure rather than producing confinement (Working Plan 4.4).

In short: the toy models illustrate the *obstruction template*; they do not
supply the *dynamics*. That separation is exactly the locked boundary rule.

---

## 5. Recommended exact wording for P1 / P1.5 / QCD outlook sections

### 5.1 P1 claim-boundary paragraph (use verbatim)

> This paper proves one exact finite mechanism: a finite bundle of null spinor
> momenta has invariant mass precisely to the extent that its directions fail to
> remain projectively collinear. We do not derive QCD confinement, electroweak
> symmetry breaking, Yukawa matrices, neutrino masses, or the observed mass
> spectrum. Those are later operator and dynamics layers.

### 5.2 P1 QCD outlook box (use verbatim)

> QCD supplies confinement and dynamics; Plucker supplies invariant accounting.
> The Plucker theorem is not a derivation of the proton mass. It is the finite
> invariant that any null/relativistic constituent account must reproduce once a
> confined momentum distribution is given. QCD remains the dynamics that supplies
> confinement, running, Lambda_QCD, the trace anomaly, and the hadron spectrum.
> We do not derive the QCD trace anomaly or the hadron spectrum; QCD dynamics is
> an input/future layer.

### 5.3 P1.5 QCD scope sentence (use verbatim)

> QCD is out of scope for the P1.5 toy theorems. We define no obstruction map
> `B_QCD`. A future `B_QCD` would require a finite color Hamiltonian or
> color-holonomy gap theorem of the form `H_color^finite` restricted to singlets
> `>= Delta > 0` under explicit finite graph and boundary assumptions; until such
> a theorem exists, QCD remains a conceptual bridge, not a null-edge mechanism
> theorem.

### 5.4 Claim-ledger line for `B_QCD` (use verbatim)

```text
B_QCD
  Status: not yet available; QCD remains boundary/motivation until a finite
  color-gap theorem exists.
```

### 5.5 Wording prohibitions (enforce in review)

- Never write any sentence implying "the Plucker theorem derives the proton
  mass" or "Plucker mass derives proton mass."
- Never define `B_QCD` by analogy to `B_Pl`, `B_Y`, `B_EW`, or `B_Higgs`.
- Never state confinement, the running coupling, `Lambda_QCD`, the trace anomaly,
  or the hadron spectrum as program outputs; they are inputs / future layers.
- Do not use "spectral gap" as a universal slogan for the Plucker mass; reserve
  it for genuine operator/Hamiltonian/Hessian spectra (convention lock).

---

## 6. Is any QCD-related Aristotle proof job appropriate now?

**Recommendation: No.** No QCD-labelled theorem should enter the current
theorem waves. Concretely:

- **Do not** queue any Aristotle job named or framed as `B_QCD`, color
  Hamiltonian, color-holonomy gap, confinement, or hadron mass. There is no
  finite structure `S`, no canonical map, and no gap theorem to target, so such a
  job would either be vacuous or would smuggle in an overclaim.
- **Allowed instead (writing/audit work, not theorem-wave physics):**
  1. Land the fixed boundary sentence, the P1/P1.5 wording from Section 5, and
     the trace-anomaly/spectrum disclaimer.
  2. Keep the `B_QCD` ledger entry as "not yet available."
- **Optional and low-priority (abstract math only, clearly de-labelled):** the
  finite toy lemmas T1/T2 from Section 3 *may* be given to Aristotle, but only
  as neutral finite-linear-algebra / finite-graph gap lemmas with no QCD naming
  and with the Section 3 guardrails attached. These are templates, not QCD
  results, and should not be scheduled ahead of the program's higher-priority
  finite targets (Yukawa checkerboard, Abelian Higgs link stiffness, electroweak
  stabilizer, null scalar kinetic reconstruction, super-Dirac square sign audit;
  Working Plan 17.10 / 20.11).

**Trigger for revisiting.** Open a QCD theorem job only after a finite color
structure `S`, a canonical finite map `B_QCD` determined by `S`, and a gap
theorem of the form `H_color^finite|_singlets >= Delta > 0` (with explicit
finite graph/boundary assumptions and a non-vacuity certificate) are drafted
informally and survive the canonical-obstruction test of Section 2. Until then,
QCD stays out of the theorem waves.

---

## 7. Guardrail compliance check

- Did **not** define `B_QCD` by analogy alone (Sections 2, 6; explicitly
  prohibited in 5.5).
- Did **not** imply Plucker mass derives proton mass (Sections 1, 4, 5.5).
- Kept confinement, running, `Lambda_QCD`, trace anomaly, and hadron spectrum
  outside all current theorem claims (Sections 1, 4, 5, 6).
- All proposed toy models are de-labelled, assumption-explicit, and accompanied
  by non-derivation disclaimers (Sections 3, 4).
