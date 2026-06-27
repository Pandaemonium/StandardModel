# Null-edge FMS-style finite graph W/Z composite audit

**No-build strategy/audit deliverable. Generated 2026-06-26.**

Scope and method. This is a written audit. No Lean, Lake, pre-commit, or build
command was run. It addresses the core question raised for proof-chain entry
**T11** and convention `docs/CONVENTIONS.md` -> "FMS/gauge-invariant composites"
(status: Unlocked), using the gauge/Higgs language locked in the same file, the
electroweak conventions locked there, and Sections 15.7-15.8, 16.8-16.9, and
17.3 (Theorem C) of
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`.

The schematic under audit is

```text
O_e^a = H_s^dagger tau^a U_e H_t.
```

Headline verdict.

```text
The schematic O_e^a is NOT gauge invariant. Under the locked finite-graph
electroweak gauge action it transforms as an adjoint (SO(3)) vector at the
source vertex: O^a -> R(g_s)^a_b O^b. It is gauge-covariant, not invariant.

Two corrected composites are gauge invariant:
  (singlet)  O_e        = H_s^dagger U_e H_t          [already T8 / link stiffness]
  (triplet)  W_e^a      = (1/2) tr( sigma^a X_s^dagger U_e X_t )
where X_v = (~H_v, H_v) / sqrt(H_v^dagger H_v) in SU(2) is the Higgs frame and
~H = i sigma^2 H^*. The framed triplet W_e^a is the correct FMS finite-link
W/Z composite; its leading vacuum-expansion fluctuation is the W/Z-like link
field, gauge-invariantly.
```

This keeps the convention status honest: the *gauge-invariant wording* stays
locked, the *specific FMS composite* moves from "schematic, needs review" to a
concrete corrected target, and nothing here is promoted to a prediction.

The guardrails are respected throughout: no statement that local gauge symmetry
literally breaks (the analysis is entirely in gauge-invariant / covariant
language), and the corrected W/Z composite is labelled **reconstruction /
structural theorem target**, not a prediction.

---

## 0. Conventions assumed (from the locked electroweak block)

```text
G            = SU(2)_L x U(1)_Y
H            in C^2, Y(H) = 1, Q = T_3 + Y/2
H_0          = (0, v/sqrt(2))
tau^a = T_a  = sigma^a / 2     (physics-Hermitian generators)
```

Finite-graph fields (from Theorem B / T8 and Section 16.9):

```text
phi_v = H_v   in C^2          Higgs at each vertex v
U_e           in SU(2)_L      SU(2) holonomy on directed edge e: s(e) -> t(e)
u_e           in U(1)_Y       hypercharge holonomy on the same edge (see Sec. 4)
```

Locked finite-graph gauge transformation (Theorem B, generalized to the
non-abelian doublet):

```text
H_v   -> g_v H_v                       g_v in SU(2)_L x U(1)_Y at vertex v
U_e   -> g_{s(e)} U_e g_{t(e)}^{-1}    (SU(2)_L part)
u_e   -> h_{s(e)} u_e h_{t(e)}^{-1}    (U(1)_Y part)
```

All "leading expansion" statements use the trivialization / small-holonomy
convention already locked for Theorem B:

```text
U_e = exp( i epsilon A_e ),   A_e = A_e^b tau^b,   expand in epsilon.
```

---

## 1. Deliverable 1: is `O_e^a` gauge invariant? If not, the correction

### 1.1 Direct computation: the schematic transforms in the adjoint

Apply the locked gauge action to `O_e^a = H_s^dagger tau^a U_e H_t`:

```text
H_s^dagger -> H_s^dagger g_s^dagger
U_e        -> g_s U_e g_t^{-1}
H_t        -> g_t H_t

O_e^a -> H_s^dagger g_s^dagger tau^a g_s U_e g_t^{-1} g_t H_t
       = H_s^dagger ( g_s^dagger tau^a g_s ) U_e H_t.
```

The target-vertex factors `g_t^{-1} g_t = 1` cancel cleanly. The source-vertex
factors do **not** cancel: they conjugate the inserted generator. For
`g_s in SU(2)` write the adjoint (vector) action

```text
g_s^dagger tau^a g_s = R(g_s)^a_b tau^b,    R(g_s) in SO(3).
```

Therefore

```text
O_e^a -> R(g_s)^a_b O_e^b.
```

Conclusion: `O_e^a` is **gauge-covariant** (an adjoint/triplet vector carrying a
*local* gauge index pinned at the source vertex), **not gauge invariant**. The
index `a` is a gauge index, so the three components mix under gauge
transformations and cannot individually be physical observables. The "exact
representation needs review" flag in Section 16.9 / T11 is confirmed: as written,
`O_e^a` fails the FMS requirement that physical excitations be gauge-invariant
composites.

### 1.2 Why the single doublet is not enough

A single doublet `H` saturates only one complex direction in `C^2`. The
sandwich `H_s^dagger tau^a (...) H_t` cannot carry a *global* (custodial) triplet
index because there is no second reference direction to define an orientation
that is fixed under the gauge group. The adjoint index it produces is necessarily
a gauge index. The FMS fix is to supply a full internal frame from the Higgs.

### 1.3 The corrected composites

**(a) Singlet (already the link-stiffness object, T8).**

```text
O_e = H_s^dagger U_e H_t.

O_e -> H_s^dagger g_s^dagger g_s U_e g_t^{-1} g_t H_t = H_s^dagger U_e H_t.
```

Gauge invariant by one-line cancellation. This is the composite already behind
Theorem B / T8: `|U_e H_t - H_s|^2 = |H_t|^2 + |H_s|^2 - 2 Re O_e`, whose
quadratic small-holonomy term is the gauge-boson mass. It is a single complex
scalar, so it captures the *charged-current contraction*, not the three separate
W/Z directions.

**(b) Triplet (the correct FMS W/Z composite).** Build the Higgs frame. Let

```text
~H = i sigma^2 H^*            (conjugate doublet, Y = -1)
Phi = ( ~H , H )             2x2 matrix, columns ~H and H
X   = Phi / sqrt(H^dagger H) in SU(2)   (the Higgs SU(2) frame)
```

Two algebraic facts (finite identities, good Lean lemmas):

```text
Phi^dagger Phi = (H^dagger H) I_2,     det Phi = H^dagger H   =>   X in SU(2).
Under SU(2)_L:  Phi -> g Phi           (uses sigma^2 g^* sigma^2 = g for g in SU(2))
Under U(1)_Y :  Phi -> Phi e^{i theta sigma^3}  (the hypercharge acts on the right)
```

So under the gauge group the frame transforms as

```text
X_v -> g_v X_v r_v,    r_v = e^{i theta_v sigma^3}   (a global-custodial / hypercharge factor on the right).
```

Define the framed link composite and its components

```text
W_e := X_s^dagger U_e X_t,        W_e^a := (1/2) tr( sigma^a W_e ).
```

Gauge behaviour:

```text
W_e -> (g_s X_s r_s)^dagger ( g_s U_e g_t^{-1} ) ( g_t X_t r_t )
     = r_s^dagger ( X_s^dagger U_e X_t ) r_t
     = r_s^dagger W_e r_t.
```

The local SU(2)_L factors `g_s, g_t` cancel **completely**: `W_e` is
**SU(2)_L gauge invariant**. The only residual is the right factor
`r_s^dagger ( ) r_t`, which is the *global custodial / hypercharge* rotation, not
a local SU(2)_L gauge transformation. Promoting it to full invariance is the job
of the hypercharge link (Deliverable 4). Thus `W_e^a` is the gauge-invariant
finite-link triplet, and its index `a` is now a *physical* (global custodial)
label distinguishing `W^1, W^2, W^3`, not a gauge index.

Minimal honest correction statement:

```text
Replace   O_e^a = H_s^dagger tau^a U_e H_t          (gauge-covariant, adjoint at source)
with      W_e^a = (1/2) tr( sigma^a X_s^dagger U_e X_t )   (SU(2)_L gauge invariant; global custodial triplet)
```

---

## 2. Deliverable 2: representation data at the two vertices and on the link

State the data precisely; mismatches here are the usual source of a spurious
"invariance" or a hidden gauge index.

```text
Source vertex s = s(e):
  H_s   in C^2,  fundamental 2 of SU(2)_L,  hypercharge Y = +1.
  Frame X_s in SU(2) built from (H_s, ~H_s); transforms X_s -> g_s X_s r_s.

Target vertex t = t(e):
  H_t   in C^2,  fundamental 2 of SU(2)_L,  hypercharge Y = +1.
  Frame X_t in SU(2);  transforms X_t -> g_t X_t r_t.

Directed link e: s -> t:
  U_e   in SU(2)_L, bifundamental (2, 2bar): U_e -> g_s U_e g_t^{-1}.
  u_e   in U(1)_Y,  charge (+1, -1) on its endpoints: u_e -> h_s u_e h_t^{-1}.
  Full link holonomy carries both factors of G = SU(2)_L x U(1)_Y.
```

Index bookkeeping that the corrected composite enforces:

```text
- The contraction must pair a 2bar at s with the link's 2 at s, and the link's
  2bar at t with a 2 at t. (H_s^dagger provides 2bar at s; H_t provides 2 at t;
  U_e provides 2 at s and 2bar at t.) This is why the *gauge* indices cancel.
- The free index 'a' must ride on the frame X (a global-custodial index), not on
  a gauge generator inserted between gauge-charged objects. The schematic put
  'a' on a gauge generator -> that is exactly the defect in Section 1.1.
```

Required vacuum/section data:

```text
Vacuum section:  H_v = H_0 = (0, v/sqrt(2)) at every vertex (covariant reference section).
Frame at vacuum: X_0 = I_2  (with Phi_0 = (v/sqrt(2)) I_2), so W_e|_vac = U_e.
```

---

## 3. Deliverable 3: vacuum / trivialization expansion and the leading fluctuation

### 3.1 The schematic `O_e^a` (for comparison only)

With `H_s = H_t = H_0`, `U_e = exp(i epsilon A_e)`, `A_e = A_e^b tau^b`,
`tau^a tau^b = (delta^{ab} I + i eps^{abc} sigma^c)/4`, and
`(sigma^c)_{22} = -delta^{c3}`:

```text
O_e^a = H_0^dagger tau^a H_0
      + i epsilon A_e^b H_0^dagger tau^a tau^b H_0 + O(epsilon^2)

vacuum:   O^1 = O^2 = 0,   O^3 = -v^2/4.
linear:   O_e^a |_lin = i (v^2/8) epsilon A_e^a + (v^2/8) epsilon eps^{ab3} A_e^b.
```

So even the schematic's leading fluctuation *contains* the link gauge field
components `A_e^{1,2,3}` (this is why it looked attractive). But the components
appear mixed with the constant `eps^{ab3}` piece and, crucially, the whole object
is gauge-covariant, so these "fields" are not separately observable. The
schematic captures the right ingredients with the wrong (gauge-variant) packaging.

### 3.2 The corrected triplet `W_e^a` (the actual deliverable)

At the vacuum frame `X_0 = I`, `W_e = X_s^dagger U_e X_t -> U_e`, so

```text
W_e^a = (1/2) tr( sigma^a U_e ),   U_e = exp(i epsilon A_e^b sigma^b / 2).

vacuum:   W_e^a = (1/2) tr(sigma^a)/... = 0   (a = 1,2,3),   plus the singlet (1/2)tr(U_e) ~ 1.
linear:   W_e^a |_lin = (1/2) tr( sigma^a * i epsilon A_e^b sigma^b / 2 )
                      = i (epsilon/2) A_e^a.
```

Clean result:

```text
W_e^a |_lin  =  (i/2) epsilon A_e^a,    a = 1, 2, 3.
```

The leading fluctuation of the gauge-invariant composite is, component by
component, proportional to the link gauge field `A_e^a` -- the finite-link W/Z
field -- with no constant-cross-term contamination and no residual gauge index.
This is exactly the FMS statement: *the gauge-invariant composite has the
usual W/Z field as its leading fluctuation around the vacuum section.*

Quadratic level (mass term, ties to T8/T10): for the singlet,

```text
|U_e H_t - H_s|^2 = 2 (H_0^dagger H_0) (1 - Re W^0_e) + ...
                  = (v^2 epsilon^2 / 4) ( (A_e^1)^2 + (A_e^2)^2 + (A_e^3)^2 ) + O(epsilon^4),
```

i.e. the gauge-invariant link stiffness whose quadratic part is the W/Z mass form
(consistent with Theorem B and the locked coefficient target in T10; the
photon-massless split requires the hypercharge link of Section 4).

Caveat (the locked null-edge guardrail, Section 16.10): this expansion is, by
itself, ordinary lattice gauge-Higgs structure with null labels. It becomes
null-edge content only when `e` is a null-tetrad edge and `U_e`, `H` are tied to
null-supported transport (the T13/T8/T_D package). The FMS composite audit does
not by itself earn the "null" adjective.

---

## 4. Deliverable 4: photon / stabilizer direction vs massive orbit directions

Work entirely in gauge-invariant / orbit language (no "symmetry breaks").

Stabilizer of the vacuum section. The Lie-algebra directions `X in su(2)_L + u(1)_Y`
split by their action on `H_0`:

```text
stabilizer (gapless):  X H_0 = 0   <=>   X in u(1)_em,  generated by Q = T_3 + Y/2.
orbit (massive):       X H_0 != 0   for the 3 complementary directions.
```

This is the locked structural content `ker B_EW = u(1)_em`, `rank q = 3` (T9).
In composite language:

```text
- Photon / stabilizer direction = the link-composite direction that preserves
  the Higgs frame: U_e in the U(1)_em stabilizer keeps X_s^dagger U_e X_t in the
  vacuum custodial direction, so its composite fluctuation along the broken
  directions vanishes. Equivalently the edge cost |U_e H_t - H_s|^2 is flat
  along this direction. The photon is the gapless composite.
- Massive orbit directions = the three link-composite directions W_e^{+}, W_e^{-},
  W_e^{Z} that move the frame off the vacuum section, picking up positive
  quadratic edge cost.
```

The custodial/right index of `W_e` is where the W^3-B mixing lives once the
U(1)_Y link `u_e` is included. In the locked basis,

```text
W^+_e = ( W_e^1 - i W_e^2 ) / sqrt(2)      massive composite
W^-_e = ( W_e^1 + i W_e^2 ) / sqrt(2)      massive composite
Z_e   = ( g W_e^3 - g' B_e ) / sqrt(g^2 + g'^2)   massive composite (uses u_e: B_e)
A_e^gamma = ( g' W_e^3 + g B_e ) / sqrt(g^2 + g'^2)  stabilizer composite, gapless
```

The photon composite `A_e^gamma` corresponds to the direction left invariant by
the residual right factor `r_v` of Section 1.3: the combination of custodial-3
and hypercharge that fixes the frame. This is the gauge-invariant way to say
"the photon is the unbroken U(1)_em holonomy direction" without asserting that a
gauge redundancy literally breaks.

Key separation principle (load-bearing, matches the locked guardrail):

```text
The W/Z composites are NOT gapless; the photon composite IS gapless.
Stated as: massive orbit directions move the covariant Higgs frame and acquire
quadratic edge cost; the stabilizer direction preserves it and stays gapless.
```

---

## 5. Deliverable 5: smallest useful theorem statement for a later Lean job

Give the smallest *positive* finite-algebra theorem that is robust and that a
later Lean job can formalize without continuum machinery. Recommended target is
the gauge invariance of the framed composite; everything else is supporting
lemmas.

Smallest useful theorem (gauge invariance of the framed link composite):

```text
Setup (finite, pure linear algebra over C):
  H_s H_t : C^2,  U_e : Matrix (Fin 2) (Fin 2) C  with U_e in SU(2),
  g_s g_t : SU(2),
  X (H) := Phi(H) / sqrt(star H *v H)   where Phi(H) := ![ ~H , H ],  ~H := i sigma2 * conj H.

Theorem fms_framed_composite_SU2L_invariant :
  let W (Hs Ut Ht) := star (X Hs) * Ut * (X Ht)
  W (g_s *v Hs) (g_s * U_e * g_t^{-1}) (g_t *v Ht) = star r_s * W Hs U_e Ht * r_t
  -- and in particular, restricted to the SU(2)_L action (r = 1):
  W (g_s *v Hs) (g_s * U_e * g_t^{-1}) (g_t *v Ht) = W Hs U_e Ht.
```

This reduces to the one-line group cancellation `g_s^dagger g_s = 1`,
`g_t^{-1} g_t = 1` once the frame transformation lemma `X(g H) = g * X(H) * r`
is in place. Supporting lemmas (each a self-contained finite identity, good
parallel Lean targets):

```text
L1 (frame is SU(2)):       Phi(H)^dagger Phi(H) = (H^dagger H) I   and   det Phi(H) = H^dagger H.
L2 (conj-doublet covariance): for g in SU(2),  sigma2 * conj g * sigma2 = g,
                              hence ~(g H) = g (~H)  and  Phi(g H) = g Phi(H).
L3 (naive composite is NOT invariant):  there exist g_s, a with
                              (g_s^dagger tau^a g_s) != tau^a, so
                              O_e^a (g_s H_s, g_s U_e g_t^{-1}, g_t H_t) != O_e^a.   (disproof of the schematic)
L4 (leading expansion):      with X_s = X_t = I and U_e = I + i eps A + O(eps^2),
                              (1/2) tr(sigma^a (star X_s * U_e * X_t)) = (i/2) eps A^a + O(eps^2).
L5 (singlet invariance, = T8 core):  H_s^dagger (g_s U_e g_t^{-1}) (g_t H_t) ... -> H_s^dagger U_e H_t.
```

Recommended Lean order: L5 (trivial, also closes the T8 gauge-invariance leg),
then L1, L2, then the main theorem, then L3 (disproof of the schematic) and L4
(leading-order match). L1, L2, L5 are independent and can be launched in
parallel. The whole package is finite-dimensional matrix algebra over `C` and
needs no continuum, no null-frame, and no analysis -- a `Mathlib`
`Matrix`/`SpecialLinearGroup` job.

Honest label for the theorem package:

```text
Type: structural theorem / reconstruction (S/Rec). It reconstructs the FMS
gauge-invariant W/Z picture on a finite link GIVEN the SM group, the Higgs
representation, and a vacuum section. It is NOT a prediction unless the finite
null-edge geometry forces SU(2)_L x U(1)_Y and the Y=1 doublet (it does not, yet).
```

---

## 6. Deliverable 6: phrase table -- safe formal wording vs unsafe wording

| # | Unsafe / gauge-breaking wording (avoid) | Safe formal wording (use) |
|---|------------------------------------------|----------------------------|
| 1 | "The local gauge symmetry breaks and gives the W/Z mass." | "The Higgs defines a covariant internal reference section; holonomies that move it acquire quadratic edge cost. Stabilizer directions stay gapless." |
| 2 | "`O_e^a = H_s^dagger tau^a U_e H_t` is the gauge-invariant W/Z observable." | "`O_e^a` is gauge-covariant (adjoint at the source vertex); the gauge-invariant W/Z composite is the framed triplet `W_e^a = (1/2) tr(sigma^a X_s^dagger U_e X_t)`." |
| 3 | "`W^a` is the physical W boson field." | "`W_e^a` is a gauge-invariant finite-link composite whose leading vacuum fluctuation is the W/Z-like link field." |
| 4 | "The index `a` labels the gauge directions of the W." | "The index `a` is a global custodial label distinguishing `W^1, W^2, W^3`; it is not a gauge index after framing." |
| 5 | "This predicts the W/Z masses / the photon masslessness." | "This reconstructs the W/Z mass form and the photon-massless (stabilizer) split, given the SM group, Higgs representation, vacuum section, and `g, g', v`." |
| 6 | "Null edges produce the W/Z mass." | "The link-stiffness mass form is standard gauge-Higgs structure; it becomes null-edge content only on a null-tetrad graph with null-supported transport (T13/T8 package)." |
| 7 | "The bare gauge field `A_e^a` is the observable." | "Physical W/Z excitations are gauge-invariant link composites; the bare `A_e^a` is the leading term of `W_e^a` in the trivialization expansion." |
| 8 | "The photon is what's left after breaking." | "The photon is the stabilizer (gapless) composite direction `A^gamma` preserving the Higgs frame; `u(1)_em = ker B_EW`." |
| 9 | "FMS confirms symmetry breaking is real." | "FMS-style composites express the same perturbative spectrum in manifestly gauge-invariant variables; no observable symmetry-breaking claim is made." |
| 10 | "The W/Z composite theorem is a prediction of the model." | "The W/Z composite theorem is a structural/reconstruction theorem; it is predictive only if the finite geometry forces `SU(2)_L x U(1)_Y` and the `Y=1` doublet." |

---

## 7. Recommendations for the convention ledger and T11

1. **Keep the convention status as Unlocked but narrow it.** In
   `docs/CONVENTIONS.md` -> "FMS/gauge-invariant composites", record the audit
   result: the schematic `O_e^a` is gauge-covariant (adjoint at source), and the
   corrected gauge-invariant composite is the framed triplet
   `W_e^a = (1/2) tr(sigma^a X_s^dagger U_e X_t)` plus the singlet
   `H_s^dagger U_e H_t`. The *gauge-invariant wording* stays locked; the
   *corrected composite* can be promoted from "schematic" to "current working
   composite" but not to "prediction".

2. **Update T11 in the proof chain.** Replace the "composite definition needs
   review" note with the corrected definitions and the Section 5 lemma package
   (L1-L5). Mark T11 as ready for a Lean proof job, depending on T8 (singlet
   invariance L5) and T9 (stabilizer/orbit split). Difficulty drops to
   medium once the frame lemmas L1-L2 are in place; it is finite matrix algebra.

3. **Do not over-couple to the null story.** Per Section 16.10, the composite
   audit is gauge-Higgs structure; flag explicitly that null-edge content is
   supplied only by the surrounding T13/T8 transport package, not by T11 itself.

4. **Labels.** Carry the four-way label: T11 is a **structural theorem /
   reconstruction** target. The "W/Z composite reproduces the W/Z field at
   leading order" statement is reconstruction; it is **not** a prediction and
   must not be advertised as one.

Bottom line.

```text
Schematic O_e^a: gauge-covariant, not invariant -> rejected as written.
Corrected composite: framed triplet W_e^a (gauge invariant) + singlet O_e.
Leading fluctuation of W_e^a around the vacuum frame: (i/2) epsilon A_e^a -> the W/Z link field.
Photon = stabilizer (gapless) composite; W/Z = massive orbit composites (rank 3).
Smallest Lean target: gauge invariance of W_e^a (one-line cancellation given frame lemmas L1, L2),
with L3 disproving the schematic and L4 matching the leading order.
Status: reconstruction / structural theorem, not a prediction.
```
