local newIdentifier = require(script.Parent.Identifier)

return function()
    describe("Identifier", function()
        it("should return unique strings", function()
            local identifierOne = newIdentifier("identifierOne")
            local identifierTwo = newIdentifier("identifierTwo")

            expect(identifierOne ~= identifierTwo).to.equal(true)
        end)

        it("should have correct position when a position is given", function()
            local identifierThree = newIdentifier("identifierThree", 1)
            local identifierFour = newIdentifier("identifierFour", 2)
            local identifierFive = newIdentifier("identifierFive", 1)

            expect(identifierThree ~= identifierFour).to.equal(true)
            expect(identifierThree == identifierFive).to.equal(true)
        end)

        it("should return existing identifiers", function()
            local identifierSix = newIdentifier("identifierSix")
            local identifierSeven = newIdentifier("identifierSix")

            expect(identifierSix == identifierSeven).to.equal(true)
        end)
    end)
end
