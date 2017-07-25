/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Deepak Nadig <deepaknadig@cse.unl.edu>
 * Creation Date: Jul 25, 2017 at 8:36:53 AM
*********************************************/

// Pre-processing
execute PARAMS {
  cplex.tilim = 100;
}

execute SETTINGS {
  settings.displayComponentName = true;
  settings.displayWidth = 40;
  writeln("Results: ");
}

int FixedCost = ...;
int NumSCs = ...;
int NumFlows = ...;

assert
  ( NumFlows > NumSCs );


range ServiceChains = 1 .. NumSCs;
range Flows = 1 .. NumFlows;


int Capacity[s in ServiceChains] = ...;

int FlowProcessingCost[f in Flows][s in ServiceChains] = ...;


// Decision Variables
dvar int Assign[ServiceChains] in 0 .. 1;
dvar float TotalFlowProcCost[Flows][ServiceChains] in 0 .. 1;

// Decsion Expression
dexpr int TotalFixedCost = sum ( s in ServiceChains ) ( FixedCost * Assign[s] );
  
dexpr float TotalMappingCost = sum ( s in ServiceChains, f in Flows )
   FlowProcessingCost[f][s] * TotalFlowProcCost[f][s];

// Model Definition
minimize
  TotalFixedCost + TotalMappingCost;

subject to {
  forall ( f in Flows )
    Constraint01:
      sum ( s in ServiceChains ) TotalFlowProcCost[f][s] == 1;

  forall ( s in ServiceChains )
    Constraint02:
      sum ( f in Flows ) TotalFlowProcCost[f][s] <= Assign[s] * Capacity[s];

}