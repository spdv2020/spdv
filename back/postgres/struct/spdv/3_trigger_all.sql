CREATE OR REPLACE FUNCTION spdv.data_atualizacao() RETURNS TRIGGER AS $$
BEGIN
  IF row(NEW.*) IS DISTINCT FROM row(OLD.*) THEN
    NEW.data_atualizacao = NOW(); 
    RETURN NEW;
  ELSE
    RETURN OLD;
  END IF;
END
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  i record;
BEGIN
  FOR i IN (
	  SELECT 
      'CREATE TRIGGER ' || t.table_name || '_dt_update BEFORE UPDATE ON ' || t.table_schema || '.' || t.table_name || ' FOR EACH ROW EXECUTE PROCEDURE spdv.data_atualizacao();' AS create_sql
		  FROM 
        information_schema.tables t
		  WHERE
        t.table_schema = 'spdv'
  ) LOOP
    EXECUTE i.create_sql;
  END LOOP;
END;
$$;