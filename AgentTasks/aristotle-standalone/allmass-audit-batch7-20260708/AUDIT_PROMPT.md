# Fable-5 semantic-alignment review — S1-CC presentation-existence (call-10)

You are a frontier-model reviewer for a Lean 4 formalization program. Blind to the
repo; everything is in this packet + the embedded verbatim Lean. The kernel already
checks the PROOFS — your job is SEMANTIC ALIGNMENT: does the kernel statement mean
what the manuscript claims, and is the grade upgrade honest? Do NOT re-verify proofs.

## Grades

**M** = kernel-checked, guard-pinned, axiom-audited `[propext, Classical.choice,
Quot.sound]`. **MEMO** = prose pending transcription. **C** = pre-registered
conjecture with kill.

## The claim under review (the program's #1 crux)

The "closure Krein form" `M = J Q_C` is claimed **not** positive on the physical
Gauss sector `V'/N = ker Q_G / range Q_G` — it is *balanced* (equal +/− eigenvalue
counts). Prior work proved: the balance ENGINE, the 6×6 WITNESS, and the general
balance MECHANISM (`compression_balanced_eigbasis`: compression of `M` by any
`b`-eigenvector family `P` is balanced). The **last** piece was existence of a
`b`-adapted presentation of the *actual* sector `V'/N`. The manuscript now claims
that is closed (**M**), so the whole crux is kernel-checked.

**Crucial history (why I need a hard look).** A FIRST attempt stated the existence
with `Q_G` Hermitian AND nilpotent — which over ℂ forces `Q_G = 0` (a definite
Hermitian nilpotent vanishes), degenerating the "sector" to the whole carrier. That
degenerate version was proved and then REJECTED (two prior reviews caught it). The
embedded version drops Hermiticity.

## The exact questions

1. **Is `physical_sector_b_eigenbasis_exists` genuinely non-degenerate now?** Its
   hypotheses: `d` a ±1 grading, `QG` nilpotent (`QG*QG=0`, NO Hermitian), `QG`
   commutes with `diagonal d`. Its conclusion produces `P, e` with: `±1` eigen
   (`diagonal d * P = P * diagonal e`), `QG*P=0`, **`card κ = card ι − 2*QG.rank`**,
   `∃ L, L*P=1` (left inverse ⇒ lin. indep.), and complementarity `∀ v, QG*ᵥv=0 →
   ∃ w z, v = P*ᵥw + QG*ᵥz`. Do these hypotheses admit a genuinely nontrivial `Q_G`
   (they must NOT force `Q_G=0`), and do the dimension + complementarity clauses
   actually pin `P` to present the full `V'/N`? Is there any residual vacuity or
   hidden degeneracy?

2. **Is the dimension count right?** `card κ = card ι − 2·rank Q_G`. Given
   `range Q_G ⊆ ker Q_G` (from `Q_G²=0`), `dim(ker/range) = (card ι − rank) − rank`.
   Confirm or refute `= card ι − 2 rank`.

3. **`physical_sector_balanced` scope.** Its exported `∃` keeps `QG*P=0` and
   `∃L, L*P=1` but DROPS the `card κ` clause. So on its own it says "some lin.-indep.
   `b`-adapted `P` in `ker Q_G` has `PᴴMP` balanced." The manuscript therefore cites
   `physical_sector_b_eigenbasis_exists` (which keeps the dimension pin) for the
   full-`V'/N` guarantee, and only uses `physical_sector_balanced` for the balance
   of the compression. Is that split honest, or is `physical_sector_balanced` being
   passed off as more than it states? Could its `∃` be satisfied by a cheap
   low-dimensional `P` (making it vacuous), or does the balance requirement + the
   witnessing full-`P` keep it substantive?

4. **The abstract argument** (`S1CCEigenbasis`): nilpotent `φ` commuting with a ±1
   involution `β` ⇒ `range φ ⊆ ker φ`, both `β`-invariant, `β` splits a complement
   along its ±1 eigenspaces. Any gap between this abstract lemma and the matrix
   application (e.g. is `mulVecLin` faithful, are the finrank identities used
   soundly)?

5. Any docstring-outruns-kernel or false-shape issue.

## Output

A definite ruling per question — especially (1) and (3): is the crux HONESTLY closed
to **M**, or is there a residual over-claim? If the latter, the exact minimal
wording/statement fix. Be adversarial; the prior two iterations had real defects, so
assume this one might too until you've checked.
