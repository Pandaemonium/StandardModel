import PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding

#eval decide (Wzero * Bfix = Bfix * Afix0)
#eval decide (Wfour * Bfix = Bfix * Afix4)
#eval decide (Bfix.transpose * Wzero * Bfix = Afix0)
#eval decide (Bfix.transpose * Wfour * Bfix = Afix4)
