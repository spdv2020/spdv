CREATE OR REPLACE FUNCTION spdv.cliente_valida_cpf() RETURNS TRIGGER AS $$
def cpf_validate(numbers):
  cpf = [int(char) for char in numbers if char.isdigit()]
  if len(cpf) != 11:
    return False

  if cpf == cpf[::-1]:
    return False

  for i in range(9, 11):
    value = sum((cpf[num] * ((i+1) - num) for num in range(0, i)))
    digit = ((value * 10) % 11) % 10
    if digit != cpf[i]:
      return False
  return True

cpf = TD['new']['cpf']
if cpf_validate(cpf) == False:
  raise Exception('CPF Inválido')
$$ LANGUAGE plpython3u;

CREATE TRIGGER cliente_cpf
  BEFORE INSERT OR UPDATE ON spdv.clientes
  FOR EACH ROW
  EXECUTE PROCEDURE spdv.cliente_valida_cpf();