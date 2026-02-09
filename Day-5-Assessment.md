# Day Tasks Documentation

## Task 1: Creating the Virtual Machine Scale Set (VMSS)

### Step 1: Create the Base Virtual Machine
- Create a Virtual Machine with all required configurations such as:
  - OS (Windows or Linux)
  - VM size
  - Networking (VNet, Subnet, NSG)
  - Required software installations
- This VM will act as the *base VM* for image creation.

---

### Step 2: Create an Image from the VM
- Stop the VM.
- Decide the image type:
  - *Specialized Image*: Keeps machine-specific data.
  - *Generalized Image*: Removes machine-specific data (recommended for scale sets).
- Create the image from the VM using Azure Portal / CLI.

---

### Step 3: Create Virtual Machine Scale Set from the Image
- Create a *Virtual Machine Scale Set* using the created image.
- Enable *automatic scaling*.
- Configure:
  - Minimum instance count
  - Maximum instance count
  - Default (desired) instance count
