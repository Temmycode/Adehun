THIS IS THE REQUIREMENT DOCUMENT FOR ADEHUN ESCROW

CORE CONCEPTS
1. Depositor - Person who is recieving service (Deposits money)
2. Beneficiary - Person that recieves the money. (Delievers service)
3. Conditions - requirements met for funds to be released

BASIC ESCROW FUNCTIONS
[ ] Create Conditions for the agreement for the release of the product
[ ] Create an Agreement
[ ] Assets to show proof for conditions
[ ] Money is released on conditions met


ESCROW STATUS FLOW STATES
DRAFT
→ PENDING_ACCEPTANCE
→ ACTIVE (funded)
→ CONDITIONS_IN_PROGRESS
→ CONDITIONS_MET
→ COMPLETED (funds released)
→ DISPUTED
→ CANCELLED
→ REFUNDED

HOW ESCROW WORKS
1. Anybody initiates the Escrow
2. Other person accepts -> Work Starts <- If accepted: else [ if it has passed a day send notification to Buyer ]
3. Funds are deposited
4. Work starts i.e agreement marked as active
5. Conditions are created for the agreement
6. Conditions are only marked as MET if it has been reviewed and approved by the Other Party
7. A condition can have multiple assets
8. Assets can be marked as approved to state that the condition has been met or can be rejected to continue with that condition
9. If all conditions are met then funds are withdrawn and then payed to the Beneficiary

REQUIREMENTS
1. The application on free tier doesn't allow the users to have more than one agreement
2. Premium users can have multiple agreements at a time 
