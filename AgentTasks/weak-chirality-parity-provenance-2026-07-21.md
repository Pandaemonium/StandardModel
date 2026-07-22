# Provenance and grading note: chirality as fermion parity (Aristotle job `8a4e09a4`)

Date: 2026-07-21
Author: Opus / Claude (AFPL co-executor)
Status: **binding on the harvest of `8a4e09a4`** - apply this grading when the
artifact lands, before writing any docstring or manuscript sentence.

## Why this note exists

I proposed the identification `chi = -(-1)^N` (chirality operator = minus the
fermion-parity operator of the two weak modes) as the fix for a prose-only join in
the repository's left-handedness claim, and I initially described it to Codex as my
observation. A literature pass afterwards shows **the physical observation is already
in the source literature**. The Lean derivation is still worth landing; the grading and
the credit are not what I first said.

## What the literature already says

1. **Furey, arXiv:1806.00612** (the paper the repository's construction follows),
   section 5.2 and the passage immediately after eq. (32): the leptonic minimal right
   ideal `L = V_R v_w + V_L v_w beta_1' + E-_L v_w beta_2' + E-_R v_w beta_1' beta_2'`
   *"resembles a Fock space, with the right-handed neutrino acting as the (formal)
   vacuum state"*, and *"the SU(2) symmetries of our ladder operators are found to act
   automatically on lepton states of only a single chirality. That is, without the need
   to impose a chiral projector by hand."*

   So Furey states both halves informally: the ideal is a Fock space graded by
   occupation, and the chirality selectivity is automatic. What she does not do - and
   what the repository therefore also did not have - is write the grading operator
   explicitly as a function of the number operator and derive the selectivity from
   number conservation.

2. **Todorov, arXiv:2206.06912** ("Octonion Internal Space Algebra for the Standard
   Model"), section on superselection rules / restricted particle subspace, is more
   explicit and closer still: *"chirality in the particle subspace ... is determined by
   the hypercharge: `P = P(nu_R - nu_L) = P(-1)^{3Y}`."*

   That is exactly a **chirality-equals-a-parity-of-a-charge** statement. It is the same
   idea as `chi = -(-1)^N`, expressed through hypercharge rather than through the weak
   occupation number.

## Consequences for grading

* The physical identification is **`[comp]`**, not `[orig]`. Cite Furey 1806.00612
  (Fock-space structure of the leptonic ideal; automatic single-chirality action) and
  Todorov 2206.06912 (chirality as `(-1)^{3Y}`).
* The **contribution is the kernel-checked derivation**: writing the grading as an
  explicit polynomial in the number operator, deriving commutation with `su(2)_L` from
  number conservation rather than by matrix computation, obtaining the `1 + 2 + 1`
  content as a consequence, and exhibiting the sharpness witness. That packaging is
  `[orig]`, and it is what de-circularizes the repository's own development.
* Do **not** write that this paper/module discovers that chirality is a parity. Write
  that it *derives, in the kernel, the selectivity that Furey states informally and
  Todorov records as a hypercharge parity*.

## One precision worth keeping

Todorov's parity is in the **hypercharge**, mine is in the **weak occupation number**.
They agree on the leptonic ideal because hypercharge there is itself a function of
occupation, but they are not the same operator in general, and the note should say
which one a given statement uses. In the two-mode model the relevant operator is
`N = B1^dag B1 + B2^dag B2 = diag(0,1,1,2)` and the grading is `-(-1)^N`.

## Residual supplied input (unchanged by any of the above)

Even after the derivation lands, **the identification of weak-mode fermion parity with
spacetime handedness remains a supplied physical input.** Nothing in the algebra makes
the `N`-odd sector left-handed rather than right-handed; that is a labelling fixed by
matching to experiment. This sentence should survive into the manuscript.

## Process lesson

This is the second grading error caught by literature in one day (the first was the
`Lambda` frame-blindness gloss, refuted by Torquato's definition of disordered
hyperuniformity as statistically isotropic). Both would have been caught by searching
the domain literature *before* writing the claim rather than after submitting the job.
Adopting that ordering as standing practice.
