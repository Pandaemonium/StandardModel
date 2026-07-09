# Strategy / no-go: is the carrier and its four-block square essentially unique? (F2)

## Context (blind to the wider repo)

A finite null-edge Dirac program builds "carriers" `D = Σ_e c(α_e) ∇_e + Γφ` (finite
null covector solderings `c(α_e)` with `c(α)²=0`, covariant transports `∇_e`, a
chiral grading `Γ`, a covariantly-constant turn field `φ`, over a Krein/indefinite
inner product). It proves the **square** decomposes into four force-shaped channels:
aperture `Q_A = Σ g(∇,∇)`, closure `Q_C` (signed, `[c,c][∇,∇]`-type), turn
`Q_T = φ²`, soldering `E_# = φ(∇^# − ∇)`. The program's central conjecture is
**"unification is decomposition"** — but this is only meaningful if the four-block
decomposition is *forced*, not a choice.

## Your task (the rigidity/classification question — the most elegant frontier)

Decide, as sharply as the finite setting allows:

**Given the carrier axioms (finite null soldering with `c(α)²=0`, Krein structure,
chiral grading `Γ` with `Γ²=1` and `{Γ, c(α)} = 0`, covariantly-constant turn `φ`),
is the operator `D` and its four-block square `4 D^#D = Q_A + Q_C + 4Q_T + 4E_#`
essentially UNIQUE (up to the obvious equivalences), or not?**

Concretely, pursue any of:
1. **Uniqueness (rigidity) theorem.** Prove that any operator satisfying the axioms
   has a square that decomposes into exactly these four grade-typed channels, with no
   fifth independent block and no ambiguity in the split — a finite universality
   class. Identify the precise equivalence (basis / gauge / similarity) under which
   "essentially unique" holds.
2. **Non-rigidity (a counterexample).** Exhibit **two inequivalent carriers**
   satisfying the axioms whose squares decompose *genuinely differently* (different
   channel content, or a fifth forced block). This is an equally valuable result — it
   says the program needs an extra selecting axiom, and identifies what it must fix.
3. **The forced-fifth-block test.** Determine whether the grade/parity bookkeeping of
   `D^#D` under `Γ` and the Krein adjoint `#` admits exactly four independent
   channel types, or whether a fifth (e.g. a genuinely soldered `[c(α),c(β)]` mixing,
   or a `Γ`-odd remainder) is forced.

Start small and concrete (one or two edges, low Clifford dimension) where the
classification is a finite computation, then state what generalizes.

## Constraints

Kernel-checked only for any proved theorem: no `sorry`/`admit`/`native_decide`/new
`axiom`; footprint `[propext, Classical.choice, Quot.sound]`, guarded in-file. Mathlib
only. Deliver Lean file(s) + `ARISTOTLE_SUMMARY.md` with a definite verdict: rigid
(with the theorem + the equivalence), or non-rigid (with the explicit inequivalent
carriers / the fifth block), or — if the full classification is out of reach finitely
— the strongest partial (e.g. the parity/grade constraint fixing the *number* of
channel types) plus the precise remaining question and its kill condition.
