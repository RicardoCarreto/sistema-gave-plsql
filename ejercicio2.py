contactos=[]
while True:
    apellidos=input("Ingrese su apellido o deje en blanco para finalizar la captura: ")
    if apellidos=="":
        break
    nombre=input("Ingrese su nombre: ")
    correo=input("Ingrese su correo: ")

    contactos.append([apellidos,nombre,correo])


if contactos:
    print(f'\n{"REPORTE DE CONTACTOS":^70}')
    print("=" * 70)
    print(f'{"Apellidos":20s} | {"Nombre":20s} | {"Correo":20s}')
    print("=" * 70)
    for contacto in contactos:
        print(f"{contacto[0]:20s} | {contacto[1]:20s} | {contacto[2]:20s}")
    print("=" * 70)
else:
    print("NO SE REGISTRARON CONTACTOS")