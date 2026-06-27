# Null-edge super-Dirac sign and double-counting audit

**No-build strategy/audit deliverable. Generated 2026-06-26.**

This report answers the audit job in `PROMPT.md`. No Lean, Lake, pre-commit, or
build/check command was run. Every algebraic claim below is a by-hand operator
computation; the recommended Lean target in Section 6 must still be elaborated
and kernel-checked before being trusted.

Sources consulted:

- `docs/NULLSTRAND.md` ("Super-Dirac square guardrails", "Frame term and tetrad
  compatibility").
- `AgentTasks/null-edge-unified-mass-proof-chain.md`, entries **T13-T16**.
- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md`, Sections
  **C.2**, **D.6**, **E.3**.
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`, Sections **17-19**
  (esp. 17.4, 18.6, 19.3).

## 0. Conventions and standing hypotheses

Operator architecture (NULLSTRAND core convention; Working Plan 19.3):

```text
D_N = sum_a C_a nabla_a            C_a = c(alpha^a)   (dual-soldered)
D   = i D_N + Gamma_s Phi          Phi = Phi_H        (internal mass block)
```

The active null support is `ell_a`; the Clifford symbol is the dual covector
`alpha^a` with `alpha^A(ell_B) = delta^A_B`. Do **not** revive the diagonal
`sum_a c(ell_a^flat) nabla_{ell_a}` (diagonal trace obstruction).

Three gradings are kept strictly separate (NULLSTRAND; Working Plan 18.6):

```text
Gamma_s        spacetime chirality
chi_E          internal finite grading
epsilon_form   cochain/form degree (if present)
```

Baseline "clean" hypotheses (the `+Phi^2` regime):

```text
(H1) Gamma_s^2       = 1
(H2) {Gamma_s, C_a}  = 0      (Gamma_s C_a = -C_a Gamma_s)
(H3) [Gamma_s, nabla_a] = 0   (Gamma_s nabla_a = nabla_a Gamma_s)
(H4) [Gamma_s, Phi]  = 0      (Gamma_s Phi   =  Phi Gamma_s)
(H5) [C_a, Phi]      = 0      (C_a Phi       =  Phi C_a)
```

Throughout, `i` is the central scalar with `i^2 = -1` (it commutes with every
operator). All sums over `a` are finite, and `D_N^2 = sum_{a,b} C_a nabla_a C_b
nabla_b`; the cross-term derivation below is per-mode and extends by bilinearity.

## 1. The square under the clean hypotheses (audit question 1)

Expand directly:

```text
D^2 = (i D_N + Gamma_s Phi)(i D_N + Gamma_s Phi)
    = i^2 D_N^2
      + i (D_N Gamma_s Phi + Gamma_s Phi D_N)
      + Gamma_s Phi Gamma_s Phi.
```

**Step A -- the kinetic term.** `i^2 D_N^2 = -D_N^2`. No hypothesis needed.

**Step B -- the zero-order (mass) term.** Using (H4) then (H1):

```text
Gamma_s Phi Gamma_s Phi = Gamma_s Gamma_s Phi Phi = Gamma_s^2 Phi^2 = +Phi^2.
```

This is the single sign that matters most. It is `+Phi^2` **iff** `Phi`
commutes with the *same* `Gamma_s` that appears in `D`.

**Step C -- the cross (gradient) term.** First, `D_N` is odd under `Gamma_s`:

```text
Gamma_s D_N = sum_a Gamma_s C_a nabla_a
            = sum_a (-C_a Gamma_s) nabla_a        (H2)
            = - sum_a C_a nabla_a Gamma_s          (H3)
            = - D_N Gamma_s.                        => {Gamma_s, D_N} = 0.
```

Then, with (H4):

```text
D_N Gamma_s Phi + Gamma_s Phi D_N
  = D_N Phi Gamma_s + Phi Gamma_s D_N             (H4: Gamma_s Phi = Phi Gamma_s)
  = D_N Phi Gamma_s - Phi D_N Gamma_s             (Gamma_s D_N = -D_N Gamma_s)
  = [D_N, Phi] Gamma_s.
```

The commutator collapses to a single Clifford factor using (H5):

```text
[D_N, Phi] = sum_a (C_a nabla_a Phi - Phi C_a nabla_a)
           = sum_a (C_a nabla_a Phi - C_a Phi nabla_a)   (H5)
           = sum_a C_a [nabla_a, Phi].
```

Finally relocate `Gamma_s` to the front. `Gamma_s` commutes with `[nabla_a,Phi]`
(by H3 and H4) but anticommutes with `C_a` (H2):

```text
( sum_a C_a [nabla_a, Phi] ) Gamma_s
  = sum_a C_a [nabla_a, Phi] Gamma_s
  = sum_a C_a Gamma_s [nabla_a, Phi]              (Gamma_s commutes with [nabla_a,Phi])
  = - sum_a Gamma_s C_a [nabla_a, Phi].            (H2)
```

Therefore the cross term carries a single leading `Gamma_s`:

```text
i (D_N Gamma_s Phi + Gamma_s Phi D_N)
  = i [D_N, Phi] Gamma_s
  = - i Gamma_s sum_a C_a [nabla_a, Phi].
```

**Result.**

```text
D = i D_N + Gamma_s Phi

D^2 = - D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi].
```

This matches PROMPT audit question 1, NULLSTRAND, proof-chain **T14**, and
Working Plan 17.4 / 18.6 / 19.3 exactly.

**Kinetic decomposition (T14 companion, NULLSTRAND "Frame term").**

```text
D_N^2     = Box_null + C_diamond + T_frame
Box_null  = 1/4 sum_{a,b} {C_a, C_b} {nabla_a, nabla_b}
C_diamond = 1/4 sum_{a,b} [C_a, C_b] [nabla_a, nabla_b]
T_frame   = sum_{a,b} C_a [nabla_a, C_b] nabla_b
```

so the fully expanded square is

```text
D^2 = - Box_null - C_diamond - T_frame + Phi^2
      - i Gamma_s sum_a C_a [nabla_a, Phi].
```

Special cases worth recording:

- If `Phi` is covariantly constant, `[nabla_a, Phi] = 0`, the gradient term
  drops and `D^2 = -D_N^2 + Phi^2`.
- Under the finite tetrad postulate `[nabla_a, C_b] = 0` (T15), `T_frame = 0`.
- On a flat patch with constant `C_a`, `C_diamond = 0` as well, leaving
  `D^2 = -Box_null + Phi^2`.

**Mass-shell reading (matching relation).** Setting `D^2 = 0` with constant
`Phi` and the frame/diamond terms gone gives `Box_null = Phi^2`, i.e.

```text
K_h(xi) = eigenvalue(Phi_H^2).
```

In the program's mostly-minus normalization (NULLSTRAND), `Box_null` is
normalized so that `-Box_null + Phi^2 = 0` yields `p^2 = m^2`. The audit point
is only that this is **one** equation with a kinetic side and a zero-order side
(see Section 3); it is not a sum of two masses.

## 2. Sign cases and grading-confusion enumeration (audit question 2)

The table below fixes (H1)-(H3) and (H5) and varies only the `Gamma_s`/`Phi`
relation and which grading is used. `eps = +1` for commuting, `eps = -1` for
anticommuting.

| # | Relation of Phi to the chirality in D | Zero-order term | Gradient term | Physical reading |
|---|----------------------------------------|-----------------|---------------|------------------|
| A | `[Gamma_s, Phi] = 0` (Phi even under the *same* Gamma_s) | `+ Phi^2` | `- i Gamma_s sum_a C_a [nabla_a, Phi]` | **Correct.** Healthy mass `m^2 = spec(Phi^2) >= 0`. |
| B | `{Gamma_s, Phi} = 0` (Phi odd under the *same* Gamma_s) | `- Phi^2` | `+ i Gamma_s sum_a C_a [nabla_a, Phi]` | **Tachyonic.** Wrong-sign mass; the single most likely silent error (C.2). |
| C | Phi odd under `chi_E` but even under `Gamma_s` (the *intended* design) | `+ Phi^2` | `- i Gamma_s sum_a C_a [nabla_a, Phi]` | **Correct**, and is the design target: internal grading carries the chirality flip, spacetime chirality does not. |
| D | `chi_E` silently substituted for `Gamma_s` in the proof | flips to `- Phi^2` if the proof uses `chi_E`-oddness as if it were `Gamma_s`-oddness | flips sign | **Spurious tachyon** from grading confusion; algebra is "right" but about the wrong operator. |

Derivation of the odd case (row B), `{Gamma_s, Phi} = 0`:

```text
Gamma_s Phi Gamma_s Phi = - Phi Gamma_s Gamma_s Phi = - Phi Gamma_s^2 Phi = - Phi^2,

D_N Gamma_s Phi + Gamma_s Phi D_N
  = - D_N Phi Gamma_s - Phi Gamma_s D_N
  = - D_N Phi Gamma_s + Phi D_N Gamma_s
  = - [D_N, Phi] Gamma_s = + Gamma_s sum_a C_a [nabla_a, Phi].
=> i(...) = + i Gamma_s sum_a C_a [nabla_a, Phi].
```

So flipping `Phi` from even to odd under the chirality in `D` flips **both** the
mass term and the gradient term. The mass term flip (`+Phi^2 -> -Phi^2`) is the
fatal one: it turns a real mass `m^2 >= 0` into a tachyonic `-m^2`.

**Grading-confusion failure modes (audit question 2, expanded).**

- **F1. `chi_E` read as `Gamma_s`.** The Higgs/Yukawa block is *internally* odd
  (`{chi_E, Phi} = 0`) but must be *spacetime-chirality even* (`[Gamma_s, Phi]
  = 0`). If a proof or a notation collapses `chi_E` and `Gamma_s` into one
  symbol, the "oddness" of `Phi` migrates onto `Gamma_s` and the square lands in
  row B/D (tachyon). NULLSTRAND states this explicitly: "If `Phi` anticommutes
  with `Gamma_s`, the square flips the sign of `Phi^2`."
- **F2. Wrong `C_a`/`Gamma_s` relation.** If (H2) is weakened to `[Gamma_s,C_a]
  = 0` (commute) instead of anticommute, then `Gamma_s D_N = +D_N Gamma_s` and
  the cross term becomes the *anticommutator* `{D_N, Phi} Gamma_s = (sum_a C_a
  {nabla_a, Phi}) Gamma_s`. This term does **not** vanish even when `[nabla_a,
  Phi] = 0`; it leaves a first-order kinetic-mass coupling `~ C_a Phi nabla_a`.
  The clean "gradient-only" cross term *requires* `{Gamma_s, C_a} = 0`.
- **F3. Phi not covariantly handled.** If `[C_a, Phi] != 0` (H5 fails) the cross
  term is `sum_a [C_a nabla_a, Phi]` and does not collapse to `C_a [nabla_a,
  Phi]`; an extra `[C_a, Phi] nabla_a` survives and contaminates the symbol.
- **F4. Box_null normalization sign.** Independent of the `Phi` sign: the finite
  `Box_null` must be normalized so `-Box_null + Phi^2 = 0` gives `p^2 = m^2`
  (mostly-minus). A sign error here mis-identifies the mass shell even when the
  `+Phi^2` term is correct.
- **F5. Mixed sign conventions in `D_N^2`.** Working Plan 17.4: if a later draft
  wants `+C_diamond` or `+T_frame` in the final square, those terms must be
  *defined* with the opposite sign from their appearance in `D_N^2`. Do not mix
  both conventions.

## 3. No-double-counting checklist (audit question 3)

The reusable checklist (Working Plan 19.3 Principle III; D.6; 18.6):

```text
[ ] Plucker / null spread  =  kinetic-symbol invariant   (lives in D_N^2 / K_h)
[ ] Phi_H^2                 =  zero-order internal mass block
[ ] K_h(xi) = eigenvalue(Phi_H^2)  is the ON-SHELL MATCHING relation
```

Read it as one equation with two sides, never as two additive masses:

```text
K_null = Phi_H^2          (operator-level on-shell relation)

FORBIDDEN:  m^2 = m_Plucker^2 + m_Higgs^2   (double counting)
```

Operational rules derived from the square:

1. **Where each quantity lives.** The Plucker/null spread is the *symbol* of the
   kinetic operator `D_N^2` (its `-Box_null` piece); `Phi_H^2` is the constant,
   zero-order term. They sit in different orders of the operator and must never
   be added as two contributions to the same elementary mass.
2. **Always exhibit the matching.** Every operator-level mass statement in P2
   must display `K_h(xi) = eigenvalue(Phi_H^2)` (or `Box_null = Phi^2`), i.e.
   the kinetic symbol *equals* the zero-order eigenvalue on shell. A statement
   that asserts a mass without this matching is suspect.
3. **No Plucker term inside `Phi_H^2`.** Do not let a second Plucker/spread
   contribution be smuggled into the internal block `Phi_H^2`. `Phi_H^2` is
   zero-order in `nabla`; a Plucker spread is second-order in the symbol.
4. **Cross term is not a mass.** The `-i Gamma_s sum_a C_a [nabla_a, Phi]` term
   is a Higgs-gradient/Yukawa-variation coupling, first order in `nabla`. It
   vanishes for covariantly constant `Phi`. It is not an additional mass term
   and must not be counted as one.
5. **Canonical-`B` discipline.** A mass is `m^2 = B^dagger B` only for a
   *canonical* obstruction `B` (Working Plan 17.7, 19.1-19.2). `B_Pl` is
   canonical (rank-one obstruction); `B_Y = M` and `B_EW(X) = X H_0` are
   canonical only once the SM field content and vacuum are fixed. Two canonical
   `B`'s for the *same* excitation would be a double count.

## 4. Fermion masses vs W/Z masses (audit question 4)

The load-bearing separation (Working Plan 19.3; D.6; NULLSTRAND):

```text
fermion masses  live in   Phi_H^2
W/Z masses      live in   |nabla^A H|^2   (Higgs covariant derivative)
                          i.e. link stiffness / orbit obstruction
```

| Sector | Block in the operator | Canonical obstruction `B` | Order in `nabla` | Claim label |
|--------|-----------------------|---------------------------|------------------|-------------|
| Charged fermion (Dirac/Yukawa) | `Phi_H^2` (zero-order internal) | `B_Y = M : E_R -> E_L` (chirality-flip gap) | 0 | reconstruction |
| W / Z gauge bosons | `\|nabla^A H\|^2` link stiffness / Higgs-orbit obstruction | `B_EW(X) = rho(X) H_0` | 2 (kinetic) | structural (given SM inputs) |
| Photon | stabilizer direction of `B_EW` | `B_EW(X) = 0` | -- | structural |

Rules:

1. **Never mix the blocks.** W/Z mass belongs to the Higgs
   covariant-derivative/link-stiffness sector (`S_H = sum_e |U_e phi_t -
   phi_s|^2`, gauge-invariant; T8), *not* to the zero-order fermion block
   `Phi_H^2`. Putting the W/Z mass into `Phi_H^2`, or the Yukawa matrix `M` into
   `|nabla^A H|^2`, is a category error.
2. **Different obstruction maps.** Fermion mass is the chirality-flip gap
   `B_Y = M` between null L/R Weyl channels (Yukawa checkerboard, T5/T6:
   `K_L = M M^dagger`, `K_R = M^dagger M`). W/Z mass is the orbit map
   `B_EW(X) = X H_0` measuring how a gauge direction moves the Higgs reference
   section (T9/T10: `ker B_EW = u(1)_em`, `rank q = 3`, `m_W = g v/2`,
   `m_Z = sqrt(g^2+g'^2) v/2`, `m_gamma = 0`).
3. **Higgs boson mass is yet another block** (radial Hessian of `V`,
   `m_h^2 = 2 lambda v^2`, T12); it is vertex-potential physics, not null-edge
   transport, and must not be conflated with a Plucker spread or with `Phi_H^2`.
4. **Gauge-invariant wording (FMS).** State W/Z mass via gauge-invariant link
   stiffness / FMS composites (`O_e^a = H_s^dagger tau^a U_e H_t`), not as an
   observable "symmetry breaking" (Working Plan 19.1 Principle IV).

## 5. Failure-mode summary

Consolidated for handoff to the proof job:

- **M1 (fatal, silent).** `Phi` odd under the *same* `Gamma_s` in `D`:
  `+Phi^2 -> -Phi^2`, tachyonic. (Row B.) Mitigation: prove `[Gamma_s, Phi] = 0`
  as an explicit hypothesis and prove the companion negative lemma.
- **M2.** `chi_E` / `Gamma_s` conflation routes you into M1 (rows C->D).
  Mitigation: distinct Lean symbols for `Gamma_s`, `chi_E`, `epsilon_form`; the
  internal oddness uses `chi_E` only.
- **M3.** `{Gamma_s, C_a} = 0` weakened to commutation: cross term becomes a
  non-vanishing anticommutator (kinetic-mass coupling), not a clean gradient.
- **M4.** `[C_a, Phi] != 0`: cross term fails to collapse to `C_a [nabla_a,
  Phi]`; a `[C_a, Phi] nabla_a` symbol contaminant survives.
- **M5.** Double counting Plucker spread and `Phi_H^2` as additive masses (D.6).
- **M6.** W/Z mass placed in `Phi_H^2` instead of `|nabla^A H|^2`.
- **M7.** `Box_null` mass-shell normalization sign (`-Box_null + Phi^2 = 0` must
  give `p^2 = m^2`).
- **M8.** Mixed sign conventions for `C_diamond`/`T_frame` between `D_N^2` and
  the final square (Working Plan 17.4).
- **M9.** Reviving the diagonal `c(ell_a^flat) nabla_{ell_a}` (trace
  obstruction) or mixing scaled `ell` with unscaled `alpha`.

## 6. Smallest Lean proof target for the graded-square job (audit question 5)

Per C.2 and the proof-chain T14, the smallest useful target is a **single-mode
abstract block lemma** in an associative `C`-algebra (or a ring of operators /
`Matrix` / `Module.End`), with one Clifford symbol `C`, one difference `Nb`,
isolating the sign logic. The finite sum over `a` is then pure bilinearity and
should be a thin corollary, so the core difficulty is fully contained here.

Recommended primary statement (positive, clean-sign case):

```lean
-- A is an associative algebra over the complex numbers (or any ring with a
-- central element `i` satisfying i^2 = -1). Gs, C, Nb, Ph : A.
theorem super_dirac_square_single
    {A : Type*} [Ring A] [Algebra C A]
    (Gs Cc Nb Ph : A)
    (hGs2  : Gs * Gs = 1)
    (hGsC  : Gs * Cc = - (Cc * Gs))          -- {Gamma_s, C} = 0
    (hGsNb : Gs * Nb = Nb * Gs)              -- [Gamma_s, nabla] = 0
    (hGsPh : Gs * Ph = Ph * Gs)              -- [Gamma_s, Phi]  = 0
    (hCPh  : Cc * Ph = Ph * Cc) :            -- [C, Phi]        = 0
    let DN := Cc * Nb
    let D  := (Complex.I • DN) + Gs * Ph
    D * D = - (DN * DN) + Ph * Ph
            - Complex.I • (Gs * (Cc * (Nb * Ph - Ph * Nb))) := by
  sorry
```

Recommended companion (audit value: the sign flips under anticommutation):

```lean
theorem super_dirac_square_single_odd
    {A : Type*} [Ring A] [Algebra C A]
    (Gs Cc Nb Ph : A)
    (hGs2  : Gs * Gs = 1)
    (hGsC  : Gs * Cc = - (Cc * Gs))
    (hGsNb : Gs * Nb = Nb * Gs)
    (hGsPh : Gs * Ph = - (Ph * Gs))          -- {Gamma_s, Phi} = 0  (Phi ODD)
    (hCPh  : Cc * Ph = Ph * Cc) :
    let DN := Cc * Nb
    let D  := (Complex.I • DN) + Gs * Ph
    D * D = - (DN * DN) - Ph * Ph
            + Complex.I • (Gs * (Cc * (Nb * Ph - Ph * Nb))) := by
  sorry
```

Notes for the proof job:

- Both are finite, analysis-free identities: expand `D * D`, then rewrite with
  the five hypotheses (`mul_assoc`, the (anti)commutation rewrites, `smul`
  pulled through via `Algebra.commutes` / `mul_smul_comm` / `smul_mul_assoc`,
  and `Complex.I_mul_I`). A `noncomm_ring`/`ring_nf` plus targeted `rw` on the
  hypotheses should close them; the only subtlety is bookkeeping the scalar `I`.
- Keep `Gs`, an internal grading `chiE`, and any `epsilon_form` as **distinct**
  variables. The positive lemma must use `[Gamma_s, Phi] = 0`; do not let an
  internal-grading hypothesis stand in for it. The contrast between the two
  lemmas above is precisely the M1/M2 guardrail made formal.
- After the single-mode pair is proven, add:
  1. the multi-mode corollary `D_N = sum_a C_a nabla_a` by `Finset.sum`
     bilinearity (gives the `sum_a` in the gradient term);
  2. the kinetic decomposition `D_N^2 = Box_null + C_diamond + T_frame` (T14
     companion lemma);
  3. the covariantly-constant corollary (`Nb*Ph = Ph*Nb` => gradient term `= 0`,
     hence `D^2 = -D_N^2 + Ph^2`), which is the cleanest entry point and a good
     warm-up sub-target.

Recommended sub-target ordering (smallest first):

```text
1. super_dirac_square_single                 (the core sign lemma)
2. super_dirac_square_single_odd             (negative companion / audit)
3. covariantly-constant corollary            ([Nb,Ph]=0 => D^2 = -DN^2 + Ph^2)
4. multi-mode sum corollary                  (Finset.sum bilinearity)
5. D_N^2 = Box_null + C_diamond + T_frame    (kinetic decomposition, feeds T15)
```

Target #1 is the single smallest object that captures the audited sign; #2 is
the load-bearing negative result that protects against M1/M2.

## 7. One-line verdict

Under (H1)-(H5) the graded square is

```text
D^2 = - D_N^2 + Phi^2 - i Gamma_s sum_a C_a [nabla_a, Phi],
```

with `+Phi^2` *iff* `Phi` commutes with the spacetime chirality `Gamma_s`;
making `Phi` odd under that same `Gamma_s` (or conflating `chi_E` with
`Gamma_s`) flips it to a tachyonic `-Phi^2`. Fermion mass lives in `Phi_H^2`,
W/Z mass in `|nabla^A H|^2`, and the Plucker spread is the kinetic side of the
single on-shell relation `K_h(xi) = eigenvalue(Phi_H^2)` -- never a second
additive mass.
