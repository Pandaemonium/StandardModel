# Null-edge conventions integration audit

Type: no-build documentation audit. No Lean, Lake, pre-commit, or build/check
command was run. This is a written patch plan only.

Provenance and sources consulted:

- `docs/CONVENTIONS.md` (current convention-lock ledger; the file this plan
  patches).
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, Section 21
  ("integration freeze before further expansion"), and the supporting Sections
  18.2, 20.2, 20.3, 20.11.
- `docs/NULLSTRAND.md` ("Super-Dirac square guardrails", "Frame term and tetrad
  compatibility"): uses `Box_null` for the kinetic mass-shell operator.
- `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`, dimension/covariance
  cautions (general-`d` simplex frame, inverse-Gram) and the null-pair
  mass/bivector projection facts (lines ~741-746).
- `AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md` (mass-shell
  normalization `-Box_null + Phi^2 = 0` gives `p^2 = m^2`; `K_null = Phi_H^2`).
- `AgentTasks/null-edge-scalar-kinetic-reconstruction-report.md` (dual-soldered
  `NullSolderFrame` data: `ell_a`, `alpha^a`, Gram/inverse-Gram).
- `AgentTasks/null-edge-flat-branch-count-protocol.md` (audit/no-go label `S`).

Note: `AgentTasks/null-edge-conventions-remainder-audit.md` is referenced as
optional in `PROMPT.md` but is **not present** in the repository; this plan does
not depend on it.

---

## 0. Standing constraints on every edit

Per the `Text and Lean hygiene` lock in `docs/CONVENTIONS.md`: keep UTF-8 without
BOM, LF endings, one final newline, no trailing whitespace, and continue to spell
placeholder/escape tokens with spaces in prose. All wording below is drafted to
respect these. Keep the existing status-label vocabulary (`Locked`, `Working`,
`Unlocked`) and add the audit label `S` (consistency check / no-go audit) only
where introduced explicitly in edit 7.

Hard discipline being encoded (Working Plan 21.1, 21.2, 21.8): **integrate before
expanding**; a locked *convention* (a notation/normalization choice) must never be
written so that it also asserts a *theorem outcome* that is still unproved.

---

## 1. Narrow the electroweak section: separate the locked convention from the
unproved `ker`/`rank` theorem target

**Where:** `## Electroweak conventions` -> `### Structural theorem`.

**Problem:** the subsection is labeled `Locked for the Standard Model electroweak
convention`, but its body displays

```text
ker B_EW = u(1)_em
rank q = 3
```

as the content. The Higgs/charge convention is genuinely lockable; the
`ker`/`rank` equalities are the *structural theorem target* and are not proved
(the file itself later says "the corresponding Lean theorem remains to be
proved"). The lock label currently spans both.

**Exact recommended replacement for `### Structural theorem`:**

```text
### Higgs and hypercharge convention

Status: Locked for the Standard Model electroweak convention.

Use the Higgs convention:

    Y(H) = 1
    Q = T_3 + Y/2
    H_0 = (0, v / sqrt(2))
    B_EW(X) = X H_0
    q(X) = |B_EW(X)|^2

This fixes notation, normalization, and the obstruction map B_EW. It does not by
itself assert the value of ker B_EW or rank q.

### Electroweak stabilizer theorem target

Status: Unlocked (structural-theorem target).

With the locked convention above, the structural theorem to be proved is:

    ker B_EW = u(1)_em
    rank q = 3

Label: structural theorem given the SM electroweak group, the Higgs
representation, and the vacuum section. Do not cite ker B_EW = u(1)_em or
rank q = 3 as established until the Lean theorem is kernel-checked; until then
state it as the target of the electroweak stabilizer job.
```

**Risk note:** the only overlock risk in the current text is precisely the one
this edit removes (a `Locked` banner sitting above `ker`/`rank` claims). The
split must keep `B_EW(X) = X H_0` and `q(X) = |B_EW(X)|^2` on the *locked* side
(they are definitions, not outcomes) and move only the `ker`/`rank` equalities to
the unlocked target. Do not relabel the stabilizer target as `Working`: `Working`
in this file means "current default you may build localized theorem statements
on", which would still overstate it. Use `Unlocked`.

---

## 2. Add safe locked conventions for simplex / tetrahedral null-solder frame
normalization

**Where:** new subsection under `## Null-edge / null-strand conventions`, placed
immediately after `### Dual-soldered Dirac architecture` (it shares the `ell_a` /
`alpha^a` data) and before `### Local frame and covariance`.

**Exact recommended new subsection:**

```text
### Null-solder frame normalization (NullSolderFrame)

Status: Locked as a data-packaging and normalization convention. The dimension
count is a convention choice, not a theorem; see the risk note.

Package a dual-soldered null frame as a single datum NullSolderFrame with:

- null directions ell_a;
- dual covectors alpha^a with alpha^A(ell_B) = delta^A_B;
- Gram data g(ell_a, ell_b) and inverse-Gram G^{ab} = g^{-1}(alpha^a, alpha^b);
- reconstruction identity xi = sum_a xi(ell_a) alpha^a;
- Clifford coefficients C_a = c(alpha^a).

Use the general-dimension simplex normalization. In d spacetime dimensions take d
spatial simplex vertex directions n_A with:

    n_A . n_B = -1/(d-1)   for A != B
    ell_A = (1, n_A)
    ell_A . ell_B = d/(d-1)   for A != B
    G^{-1} = -((d-1)/d) I + (1/d) J
    alpha^A = (1/d) dt + ((d-1)/d) n_A . dx

The tetrahedral frame is the d = 4 case. Use it for finite algebra tests and
inverse-Gram calculations.

Do not reintroduce drifting local frame definitions in scalar-kinetic,
commutator, inverse-Gram, branch-count, or square-decomposition work; import
NullSolderFrame instead.
```

**Risk note:** this is the highest overlock-risk addition, and the wording is
written to avoid it. "Four null directions form a tetrahedron" must **not** be
stated as a derivation of four-dimensional spacetime: the source explicitly warns
that `d = 4` is a *chosen case* of the simplex family, and that spacetime
dimension would need a separate spectral-dimension / anomaly / classification /
scaling theorem. The inverse-Gram formula `G^{-1} = -((d-1)/d) I + (1/d) J` is a
locked *normalization* (a definitional algebra identity), but the explicit
tetrahedral inverse-Gram *theorem* (Gate B3) remains a proof target and is not
asserted here.

---

## 3. Add a scaling-consistency rule

**Where:** new subsection under `## Null-edge / null-strand conventions`, after
`### Branch-count / no-doubling test` (both concern the flat finite-difference
symbol).

**Exact recommended new subsection:**

```text
### Scaling consistency

Status: Locked as an audit rule; the controlled continuum limit remains an
unlocked theorem target.

Finite-difference null-edge symbols must be presented with explicit edge spacing
h and a stated scaling order. The retarded symbol is

    D_+(q) = sum_a C_a (exp(i q_a) - 1) / h

so the leading symbol scales as the first finite difference. Rules:

- Always state the rescaling used before taking any continuum or long-time limit;
  do not silently drop O(h) terms.
- A relation is only scaling-consistent if it survives rescaling of fields,
  edges, and the cutoff Lambda; relations that can be moved into f, Lambda, or a
  field redefinition are not predictions.
- O(1) frame jumps across h-edges are smooth-limit contamination, not physics;
  classify them under the frame/tetrad defect rule.

Run the scaling check before promoting any finite square or branch-count result
toward a continuum claim.
```

**Risk note:** keep this labeled as an *audit rule*. The continuum/square-limit
theorem is in the `Still not fully locked` list; the scaling rule constrains how
results are presented, it does not assert that a controlled limit exists.

---

## 4. Add mass-shell normalization and the `K_null = Box_null = K_h` alias note

**Where:** new subsection under `## Null-edge / null-strand conventions`, placed
right after `### Super-Dirac square signs` (it disambiguates the operator named
there).

**Motivation:** the corpus uses three names for the same kinetic mass-shell
operator. `docs/CONVENTIONS.md` (Super-Dirac square signs) and Working Plan 21.2
write `K_h` and `K_null`; `docs/NULLSTRAND.md` and the sign/double-counting audit
write `Box_null`. This must be locked as one alias to prevent corpus drift.

**Exact recommended new subsection:**

```text
### Mass-shell operator name and normalization

Status: Locked as a naming and normalization convention. The finite square
decomposition theorem and the sign audit remain proof targets.

The kinetic mass-shell operator has three names in this corpus; treat them as one
alias:

    K_null = Box_null = K_h

Prefer K_null in new manuscript and task text; Box_null and K_h are legacy
aliases kept for compatibility with docs/NULLSTRAND.md and earlier audits.

Defining form (NULLSTRAND):

    K_null = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}

Mass-shell normalization (mostly-minus signature): the analytic d'Alembertian has
plane-wave symbol -p^2, and K_null is normalized so that

    -K_null + Phi_H^2 = 0   yields   p^2 = m^2

The operator-level on-shell relation is K_null = Phi_H^2 (one elementary mass,
not an additive sum); this is the no-double-counting convention restated at the
operator level.
```

**Risk note:** the displayed sign normalization (`-K_null + Phi_H^2 = 0` ->
`p^2 = m^2`) is a *normalization convention*, but it is adjacent to the
super-Dirac sign audit, which is an open proof target. Keep the explicit caveat
that the finite square decomposition `D_N^2 = K_null + C_diamond + T_frame` and
the `+Phi_H^2`/`-Phi_H^2` grading sign are still proof targets, not closed here.
Do not let "alias locked" be read as "square decomposition proved".

---

## 5. Add invariant versus frame-relative mass naming

**Where:** new subsection under `## Mass-unification language conventions`, after
`### Umbrella language`.

**Exact recommended new subsection:**

```text
### Invariant versus frame-relative mass

Status: Locked as a naming rule.

Distinguish two mass notions and never conflate them:

- Invariant mass: a Lorentz-invariant of a configuration, e.g. the rest-frame
  invariant m^2 = (sum p)^2 of a null bundle, or det P for the Plucker map. Use
  "invariant mass", "rest-frame invariant", or "finite invariant mass".

- Frame-relative mass: any quantity defined only after a timelike barycenter U or
  observer n is supplied as normalization data. Label it explicitly as
  frame-relative or observer-normalized.

The P1 Plucker quantity m^2 = det P = sum_{i<j} |psi_i wedge psi_j|^2 is an
invariant. When a result needs U or n, say so; do not present a frame-relative
quantity as if it were a Lorentz invariant.
```

**Risk note:** low. This only fixes vocabulary. Ensure the example stays
consistent with the Plucker-bracket edit (item 6): `det P` is the invariant; the
`wedge` lives in the exterior power.

---

## 6. Add: the Plucker bracket lives in `Lambda^2 S`, not `Sym^2 S`

**Where:** new subsection under `## Mass-unification language conventions`, after
the new invariant/frame-relative subsection (item 5), since both concern the
Plucker map.

**Exact recommended new subsection:**

```text
### Plucker bracket target space

Status: Locked.

The Plucker obstruction map lands in the second exterior power, not the symmetric
square:

    B_Pl(Psi) = (psi_i wedge psi_j)_{i<j} in Lambda^2 S

The bracket is antisymmetric: psi_i wedge psi_j = - psi_j wedge psi_i, and
psi wedge psi = 0. Mass squared is the total pairwise spread

    m^2 = det P = sum_{i<j} |psi_i wedge psi_j|^2,

which vanishes exactly when all spinors share one projective null direction
(rank-one locus). For a null pair the scalar Clifford projection gives the
Plucker mass contribution and the antisymmetric (Lambda^2) projection retains the
oriented-area/bivector data; do not place the bracket in Sym^2 S.
```

**Risk note:** low and corrective. This pins the target space and removes any
`Sym^2` mislabeling; it restates already-locked content (the `B_Pl` map and the
mass formula) so it introduces no new theorem claim. Keep the `rank-one
obstruction` language consistent with the `Current obstruction-map statuses`
ledger.

---

## 7. Add gate ordering and job label conventions

**Where:** new top-level section `## Program gate and job-label conventions`,
placed after `## Mass-unification language conventions` and before
`## Electroweak conventions`.

**Exact recommended new section:**

```text
## Program gate and job-label conventions

### Gate ordering

Status: Locked as a sequencing convention.

Integrate before expanding: do not launch new broad proof waves until returned
assumptions are triaged. Gate order is A -> B -> C -> D -> E -> F, with:

- Gate A (convention freeze) is a hard prerequisite; no finite square theorem is
  promoted until Gate A passes.
- Gate B finite-core order is B1 -> B3 -> B2 -> B4, with prerequisite B0 =
  NullSolderFrame:
    B0: NullSolderFrame data package.
    B1: simplex/tetrahedral null-solder frame in general dimension.
    B3: explicit tetrahedral inverse-Gram calculation.
    B2: diagonal trace obstruction.
    B4: full finite square decomposition.
- Gate C (branch count / stability) is a kill switch; do not launch heavy
  continuum or chirality work until C returns.
- Gates D, E, F (continuum square limit; physics audits; prediction gate) follow;
  prediction language is forbidden until a real codimension relation survives
  redundancy and field-redefinition checks.

### Job and claim labels

Status: Locked.

Every theorem, audit, and manuscript claim carries one of the four-way labels
(Representation, Reconstruction, Structural theorem, Prediction) defined under
"Claim labels", plus, for non-certifying checks, the audit label:

- S: consistency check / no-go audit. Specifies what must be computed and what
  would pass or fail; does not certify the operator or prove a positive claim.

P1 and P1.5 are reconstruction/structural-theorem work, not prediction.
Prediction begins only at the moduli-rank/codimension gate.
```

**Risk note:** moderate. The gate ordering is a *sequencing/process* convention
and is safe to lock, but it must not be read as asserting that any gate has been
*passed*. Keep the wording in terms of "order" and "prerequisite", never "done".
The `S` label must stay clearly non-certifying so an audit document is never
mistaken for a positive theorem.

---

## 8. Annotate remaining unlocked items as proof / audit / model / prediction
targets

**Where:** `## Still not fully locked`.

**Problem:** the section currently lists unlocked items as a flat bullet list
without saying *what kind* of work each needs. Working Plan 21 wants every
unsettled item triaged by target type.

**Exact recommended replacement for the bullet list (keep the surrounding
paragraphs):**

```text
The following are not settled. Each is tagged by the kind of work it needs:
proof target, audit target, model target, or prediction target.

- Exact FMS-style finite graph composite for W/Z excitations - model + audit
  target (needs the correct gauge-invariant finite-link observable before any
  Lean statement).
- Full finite-to-continuum symbol and square-limit theorem - proof target
  (Gate D).
- Determinant-level branch count and no-doubling result - audit target then
  proof target (Gate C; label S until a positive theorem exists).
- Krein physical-sector stability - audit target (necessary, not a stability
  theorem; pair the J-self-adjointness theorem with the overclaim
  counterexample).
- Chiral mechanism: internal chiral representation, domain wall, overlap-like,
  or non-Hermitian/Krein imbalance - model target then proof target.
- Anomaly/chirality audit for the full finite construction - audit target.
- Any clean finite B_QCD - model target (no definition until a finite color-gap
  theorem exists).
- Any finite-to-EFT codimension or numerical mass prediction - prediction target
  (Gate F only; forbidden language until a relation survives redundancy checks).
- Electroweak stabilizer ker/rank theorem (ker B_EW = u(1)_em, rank q = 3) -
  proof target (moved here from the electroweak section by edit 1).
```

**Risk note:** the added final bullet must be kept consistent with edit 1; the
`ker`/`rank` claim is listed in exactly one place as a proof target and nowhere
as locked. Keep the closing paragraph that says assumptions in these areas stay
labelled working/audit/reconstruction/future-prediction. Do not retag any item as
locked here.

---

## 9. Consequential edit: closing paragraph of the file

**Where:** the final paragraph of `docs/CONVENTIONS.md`.

The current closing sentence ("The electroweak coefficient normalization is now
locked as a convention, but the corresponding Lean theorem remains to be
proved.") stays correct and should be kept. Append one sentence to record this
integration pass:

```text
The electroweak ker/rank structural theorem, the finite square decomposition, and
the branch-count/no-doubling result remain proof or audit targets and are tracked
in "Still not fully locked"; locking conventions here does not lock any of those
outcomes.
```

**Risk note:** this is the global guard against the whole file being read as
"everything is proved". Low risk, high value.

---

## Summary of edits

| # | Edit | Section touched | Lock status added | Overlock risk |
|---|------|-----------------|-------------------|---------------|
| 1 | Split EW convention from ker/rank target | Electroweak conventions | Locked (conv) + Unlocked (target) | Removes an existing overlock |
| 2 | NullSolderFrame / simplex normalization | Null-edge conventions | Locked (data/normalization) | Highest: guarded against d=4 derivation claim |
| 3 | Scaling consistency | Null-edge conventions | Locked (audit rule) | Low (limit stays unlocked) |
| 4 | Mass-shell normalization + K_null=Box_null=K_h alias | Null-edge conventions | Locked (naming/normalization) | Low (square decomp stays a target) |
| 5 | Invariant vs frame-relative mass | Mass-unification language | Locked (naming) | Low |
| 6 | Plucker bracket in Lambda^2 S | Mass-unification language | Locked | Low (corrective) |
| 7 | Gate ordering + job labels | new section | Locked (sequencing) | Moderate: "order" not "passed" |
| 8 | Tag unlocked items by target type | Still not fully locked | none (annotation) | Low |
| 9 | Closing-paragraph guard sentence | end of file | none | Low |

---

## Final answer: are conventions fully locked after these edits?

No. After these edits the **convention layer** is fully locked and internally
consistent: metric signature, dual-soldering architecture, grading separation,
NullSolderFrame/simplex normalization, scaling presentation rule, the
`K_null = Box_null = K_h` alias and mass-shell normalization, invariant vs
frame-relative naming, the `Lambda^2 S` Plucker target, gate ordering, and the
job/claim-label vocabulary all become stable notational/normalization choices
with no remaining ambiguity.

But the **theorem and model layer is deliberately not locked**, and these edits
make that boundary explicit rather than closing it. Still open as proof / audit /
model / prediction targets: the electroweak `ker B_EW = u(1)_em` / `rank q = 3`
structural theorem (and its Lean proof), the super-Dirac square sign audit and
finite square decomposition, the determinant-level branch-count/no-doubling
result, Krein physical-sector stability, the chiral mechanism, the
finite-to-continuum square limit, any finite `B_QCD`, and any finite-to-EFT
codimension/numerical prediction.

So the correct post-edit statement is: **conventions are locked; the theorems,
audits, models, and predictions they describe are not.** That separation is the
intended outcome of the Working Plan Section 21 integration freeze ("integrate
before expanding"; "no trusted theorem should depend on a convention banner that
secretly asserts an unproved outcome").
