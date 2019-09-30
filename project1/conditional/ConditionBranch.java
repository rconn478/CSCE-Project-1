package project1.conditional;

import java.lang.reflect.Array;
import java.util.ArrayList;

public class ConditionBranch extends Conditional {
    ConditionType condType;
    Conditional left;
    Conditional right;

    public ConditionBranch(ConditionType condType, Conditional left, Conditional right) {
        this.condType = condType;
        this.left = left;
        this.right = right;
    }

    @Override
    public ArrayList<String> getFieldsChecked() {
        ArrayList<String> output = new ArrayList<>();
        for (String s : left.getFieldsChecked())
        {
            if (!output.contains(s))
            {
                output.add(s);
            }
        }
        for (String s : right.getFieldsChecked())
        {
            if (!output.contains(s))
            {
                output.add(s);
            }
        }
        return output;
    }

    @Override
    public boolean SelectsEntry(ArrayList<Cell> row) throws IncompatibleTypesException, FieldNotInTableException {
        if (condType == ConditionType.AND)
        {
            return left.SelectsEntry(row) && right.SelectsEntry(row);
        }
        else
        {
            return left.SelectsEntry(row) || right.SelectsEntry(row);
        }
    }

    @Override
    public boolean HashableOperation() {
        if (condType == ConditionType.OR)
        {
            return false;
        }
        return left.HashableOperation() && right.HashableOperation();
    }
}