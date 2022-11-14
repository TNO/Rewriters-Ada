package body Predefined_Rewriters_Boolean_Expression_Simplify is

   function Context (Node : Ada_Node) return Ada_Node;
   function Context (Node : Ada_Node) return Ada_Node is
      ReturnValue : Ada_Node := Node;
   begin
      while not ReturnValue.Is_Null and then ReturnValue.Kind in Ada_Expr loop
         ReturnValue := ReturnValue.Parent;
      end loop;
      return ReturnValue;
   end Context;

   function Context (Nodes : Node_List.Vector) return Node_List.Vector;
   function Context (Nodes : Node_List.Vector) return Node_List.Vector is
      Return_Value : Node_List.Vector;
   begin
      for Node of Nodes loop
         Return_Value.Append (Context (Node));
      end loop;
      return Return_Value;
   end Context;

   function Boolean_Expression_Simplify_Rewrite_Context
     (Unit : Analysis_Unit) return Node_List.Vector
   is
      Result : Node_List.Vector;
   begin
      Result.Append_Vector
        (Context (Rewriter_True_Or_Else.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_False_Or_Else.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_True_And_Then.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_False_And_Then.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Or_Else_True.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Or_Else_False.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_And_Then_True.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_And_Then_False.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Idempotence_And.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Idempotence_Or.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Complementation_And.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Complementation_Or.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Equal_True.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Equal_False.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Different_True.Matching_Nodes (Unit)));
      Result.Append_Vector
        (Context (Rewriter_Different_False.Matching_Nodes (Unit)));

      return Result;
   end Boolean_Expression_Simplify_Rewrite_Context;

end Predefined_Rewriters_Boolean_Expression_Simplify;
