const { expect } = require("chai");

describe("Restaurante Contract", function () {
    let Restaurante, restaurante;
    let owner, customer1, customer2;
    let mockERC20;

    beforeEach(async () => {
        [owner, customer1, customer2] = await ethers.getSigners();

        const MockERC20 = await ethers.getContractFactory("DREX");
        mockERC20 = await MockERC20.deploy();

        Restaurante = await ethers.getContractFactory("Restaurante");
        restaurante = await Restaurante.deploy();

        await mockERC20.mint(owner.address, 5000);
        await mockERC20.mint(customer1.address, 1000);
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await restaurante.dono()).to.equal(owner.address);
        });
    });

    describe("Prato Functions", function () {
        it("Should add a new dish", async () => {
            await restaurante.connect(owner).adicionarPrato("Asado de Ancho + Papas Fritas", 50);
            const prato = await restaurante.pratos(1);
            expect(prato.nome).to.equal("Asado de Ancho + Papas Fritas");
            expect(prato.preco).to.equal(50);
        });

        it("Should buy a dish and pay with ERC20", async () => {
            await restaurante.connect(owner).adicionarPrato("Asado de Ancho + Papas Fritas", 50);

            await mockERC20.connect(customer1).approve(restaurante.target, 50);
            await restaurante.connect(customer1).comprarPrato(1, mockERC20.target);

            const prato = await restaurante.pratos(1);
            expect(prato.vendido).to.equal(true);
        });
    });
});
