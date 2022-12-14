package body Predefined_Rewriters_Prefer_Short_Circuit is

   function Prefer_Short_Circuit_Rewrite_Context
     (Unit : Analysis_Unit) return Node_List.Vector
   is
      Result : Node_List.Vector;
   begin
      Result.Append_Vector (Rewriter_And_Then.Matching_Nodes (Unit));
      Result.Append_Vector (Rewriter_Or_Else.Matching_Nodes (Unit));

      return Result;
   end Prefer_Short_Circuit_Rewrite_Context;

end Predefined_Rewriters_Prefer_Short_Circuit;
