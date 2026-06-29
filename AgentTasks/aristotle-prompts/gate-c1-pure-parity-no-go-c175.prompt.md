Project name: gate-c1-pure-parity-no-go-c175

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current strategic context:
Earlier null-edge work used a pure product/parity point-split mass

  M_P(corner) = product_mu c_mu = (-1)^level(corner)

on four branch/Brillouin signs c_mu in {+1,-1}. This is balance-odd and useful diagnostically, but Pro and recent Aristotle work indicate it cannot isolate one physical sector in four dimensions. It gives an eight-plus-eight parity multiplet.

Problem:
Prove the finite no-go/counting theorem for pure product/parity mass in dimension 4.

Target results:
1. There are exactly 8 corners with M_P = +1 and exactly 8 corners with M_P = -1.
2. Equivalently, exactly 8 corners have even level and exactly 8 corners have odd level.
3. Therefore any mass window based only on M_P cannot distinguish the unique level-0 corner from the other even-level corners.
4. Optional comparison: give a level-linear Wilson mass W_level = r sum_mu (1 - c_mu) and prove its level table 0,2r,4r,6r,8r with multiplicities 1,4,6,4,1.

Requested output:
- Lean-ready finite theorem statements over Fin 4 signs;
- proofs or proof sketches for counts/multiplicities;
- a precise no-go statement explaining why pure parity cannot be a one-sector selector;
- optional Wilson-level comparison table.

This job is a diagnostic/no-go package, not a full Gate C1 release.
