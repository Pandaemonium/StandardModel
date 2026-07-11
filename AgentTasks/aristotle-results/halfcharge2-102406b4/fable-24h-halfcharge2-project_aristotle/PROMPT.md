# Focused successor: window half-charge, Gamma identities via block structure

Continuation of a stalled job (its snapshot is context/WindowHalfCharge.lean).
The eigenvector prefix (W_v0/W_v1/W_u0/W_u1, Wd_*, K_* theorems) is
PROOF-COMPLETE - do not modify those statements or proofs. Kernel-only
discipline (standard three axioms, no native_decide) for everything you
prove; report honestly what does not land.

RANKED TARGETS (drop lower ranks rather than weaken statements):

T1 (the four Gamma identities - the stall point). The predecessor
thrashed on entrywise 16x16 expansion. Use the BLOCK structure instead:
Gamma is block-diagonal with 2x2 site blocks G_x = c*sigma_y -
s(x)*s0*sigma_z (rational entries: [[-s(x)*3/5, -4i/5],[4i/5, s(x)*3/5]]),
W = S * C with C block-diagonal (2x2 coin blocks) and S a two-line
permutation-type matrix (component 0 shifts +1, component 1 shifts -1).
Strategies in preference order:
  (a) prove 2x2 block lemmas (G_x * coin_x * G_x = coin_x^H etc.) by
      norm_num, then assemble the 16x16 identities by Matrix.ext +
      Fin.cases on the site index (64 cases of 2x2 arithmetic each -
      each case closes fast);
  (b) if the assembly fights the shift structure, prove
      Gamma * S * Gamma = S^H and Gamma * C * Gamma = C^H separately
      (S^H = S^T = S^{-1}; C^H from the block lemmas), then compose:
      Gamma W Gamma = (Gamma S Gamma)(Gamma C Gamma) = S^H C^H =
      (C S)^H... CAREFUL: W = S*C so W^H = C^H * S^H and
      Gamma W Gamma = S^H * C^H is NOT W^H in general - CHECK the exact
      target statement in the file (Gamma * W * Gamma = W^H) against
      this factoring; the correct route is
      Gamma S Gamma = S^{-1} = S^H and Gamma C Gamma = C^{-1} = C^H,
      hence Gamma W Gamma = S^{-1} C^{-1}... which equals (C S)^{-1},
      NOT (S C)^{-1}. The identity Gamma W Gamma = W^H was verified
      numerically for THIS W, so if the naive factoring mismatches,
      the resolution lives in the specific commutation of S with the
      constant-block parts - work it out exactly rather than assuming;
      if the statement in the file is wrong as stated, REPORT that
      loudly instead of proving something else.
T2 (window charges, rational projection form): Q0win :=
  trace((Gram)^{-1} * (A^H * Piw * A)) = 1 and the same for the minus
  sector and the second window. A = the 16x2 matrix of the proven
  eigenvectors; Gram = A^H A = [[218450, -53550i],[53550i, 14450]]
  (integer entries; verify in-proof). These are 16-entry vector sums and
  2x2 traces - light compared to T1.
T3 (half-charge arithmetic): DeltaQ0 := -(Qpiwin)/2 = -1/2 and
  DeltaQpi := -(Q0win)/2 = -1/2, with the docstring disclosure that the
  bridge from filled-sea traces to these expressions is the chiral
  pairing identity (NOT proved here; a separate target).
DEFERRED (do not attempt): the spectral pairing lemma and the 16x16
phase-conjugacy statement.

Deliverable: the completed file (prefix untouched) + short memo.
