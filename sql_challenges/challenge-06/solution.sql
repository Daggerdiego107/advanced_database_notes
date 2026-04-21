-- Create a trigger that fires before inserting each row in the PET_CARE_LOG table. The trigger will assign the current date and time to the LAST_UPDATE_DATETIME column. It will also assign the current user to the CREATED_BY_USER column. Use pseudocolumns to get the values that you need. Handle all errors in one general exception handler and send an error message using the RAISE_APPLICATION_ERROR procedure.

CREATE OR REPLACE TRIGGER trg_pet_care_log_insert
BEFORE INSERT ON PET_CARE_LOG
FOR EACH ROW
BEGIN
    :NEW.LAST_UPDATE_DATETIME := SYSDATE;
    :NEW.CREATED_BY_USER := USER;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error during insert into PET_CARE_LOG: ' || SQLERRM);
END;
/

-- Create a trigger that fires before updating each row of the PET_CARE_LOG table. This trigger will look at the current user and compare it with the value in the CREATED_BY_USER column. If the two are the same, the update proceeds. If they are different, the update raises an exception and fails. Handle any other database errors the same way you did in the insert trigger.

CREATE OR REPLACE TRIGGER trg_pet_care_log_update
BEFORE UPDATE ON PET_CARE_LOG
FOR EACH ROW
BEGIN
    IF USER != :OLD.CREATED_BY_USER THEN
        RAISE_APPLICATION_ERROR(-20002, 'Update failed: You can only update your own records.');
    END IF;
    
    :NEW.LAST_UPDATE_DATETIME := SYSDATE;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20002 THEN
            RAISE; 
        ELSE
            RAISE_APPLICATION_ERROR(-20003, 'Error during update on PET_CARE_LOG: ' || SQLERRM);
        END IF;
END;
/

-- Create a trigger that fires before any row is deleted from the PET_CARE_LOG table. This trigger looks at the user who is deleting the row. If the user is ‘JOEMANAGER,’ the delete continues successfully. Otherwise, the delete fails and sends an error message. Handle any other database errors the same way you did in the insert trigger.

CREATE OR REPLACE TRIGGER trg_pet_care_log_delete
BEFORE DELETE ON PET_CARE_LOG
FOR EACH ROW
BEGIN
    IF USER != 'JOEMANAGER' THEN
        RAISE_APPLICATION_ERROR(-20004, 'Delete failed: Only the manager can delete records.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20004 THEN
            RAISE;
        ELSE
            RAISE_APPLICATION_ERROR(-20005, 'Error during delete on PET_CARE_LOG: ' || SQLERRM);
        END IF;
END;
/