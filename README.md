# One Day in Uruguay: A Blockchain Experience

This repository contains Solidity smart contracts that model a day of activities in Uruguay. From getting a haircut at a barbershop, having coffee at a café, dining at a restaurant, to even booking a local trip. All these services can be paid for using the ERC20 token DREX (BRL).

### Contracts

Here are the smart contracts included:

Barbearia: A barbershop where you can avail various services.
Cafeteria: A coffee shop with different coffee options.
DREX: An ERC20 token representing the Brazilian Real (BRL).
Restaurante: A restaurant where you can order different dishes.
ViagemUruguai: A travel agency offering local trip bookings.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

### Prerequisites
- NodeJS
- NPM/Yarn
- Hardhat

### Installation

Clone this repository:

```bash
git clone https://github.com/your-repo/one-day-in-uruguay.git
```
Install dependencies:

```bash
cd one-day-in-uruguay
npm install
```
Compile contracts:

```bash
npx hardhat compile
```

Run tests:

```bash
npx hardhat test
```

### How to Use
Barbearia

Add a new service:

```bash
npx hardhat --network localhost adicionarServico "Corte de Cabelo" 30
```

Avail a service:

```bash
npx hardhat --network localhost realizarServico 1 <ERC20_Address>
Cafeteria
Add a new coffee:

```bash
npx hardhat --network localhost adicionarCafe "Expresso" 10
Buy a coffee:

```bash
npx hardhat --network localhost comprarCafe 1 <ERC20_Address>
Restaurante
Add a new dish:

```bash
npx hardhat --network localhost adicionarPrato "Asado de Ancho + Papas Fritas" 50
Buy a dish:

```bash
npx hardhat --network localhost comprarPrato 1 <ERC20_Address>
ViagemUruguai
Issue a new ticket:

```bash
npx hardhat --network localhost emitirPassagem <Ticket_Owner_Address> "John Doe"
Do a check-in:

```bash
npx hardhat --network localhost fazerCheckin 1
Transfer a ticket:

```bash
npx hardhat --network localhost transferirPassagem 1 <New_Owner_Address>
Author
Your Name

License
This project is licensed under the MIT License.