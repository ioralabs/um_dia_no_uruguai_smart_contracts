const { expect } = require("chai");

describe("Cafeteria Contract", function () {
    let Cafeteria, cafeteria;
    let owner, account1, account2;
    let mockERC20;

    beforeEach(async () => {
        [owner, account1, account2] = await ethers.getSigners();

        // Deploy Drex contract
        const Drex = await ethers.getContractFactory("DREX");
        mockERC20 = await Drex.deploy();

        // Deploy Cafeteria contract
        Cafeteria = await ethers.getContractFactory("CoffeeShop");
        cafeteria = await Cafeteria.deploy();

        // Mint some tokens for testing
        await mockERC20.mint(owner.address, 5000);
        await mockERC20.transfer(account1.address, 1000);
    });

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await cafeteria.dono()).to.equal(owner.address);
        });
    });

    describe("Coffee Functions", function () {
        it("Should add a new coffee", async () => {
            await cafeteria.connect(owner).adicionarCafe("Mocachino Caramal", 30);
            const cafe = await cafeteria.cafes(1);
            expect(cafe.nome).to.equal("Mocachino Caramal");
            expect(cafe.preco).to.equal(30);
        });

        it("Should buy a Mocachino Caramal coffee and pay with ERC20", async () => {
            await cafeteria.connect(owner).adicionarCafe("Mocachino Caramal", 30);

            await mockERC20.connect(account1).approve(cafeteria.target, 30);

            await expect(cafeteria.connect(account1).comprarCafe(1, mockERC20.target))
                .to.emit(cafeteria, "CafeVendido")
                .withArgs(1, account1.address, "Mocachino Caramal");

            const cafe = await cafeteria.cafes(1);
            expect(cafe.vendido).to.equal(true);
        });
    });
});
