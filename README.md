# Blockchain-Based Research Project Management

This project implements a blockchain-based system for managing research projects using Clarity smart contracts. The system provides a transparent and immutable way to track research activities, allocate resources, and manage publications.

## Smart Contracts

The system consists of five main smart contracts:

1. **Research Institution Verification**
    - Validates and verifies research institutions
    - Maintains a registry of verified institutions
    - Allows admin to revoke verification if needed

2. **Project Coordination**
    - Manages research projects and their metadata
    - Tracks project collaborators and their roles
    - Handles project status updates

3. **Resource Allocation**
    - Manages allocation of resources to research projects
    - Tracks total resources allocated to each project
    - Allows updating resource allocations

4. **Progress Tracking**
    - Tracks project milestones and their completion status
    - Records project updates submitted by researchers
    - Provides visibility into project progress

5. **Publication Management**
    - Manages research publications and their metadata
    - Handles the peer review process
    - Verifies publication integrity using cryptographic hashes

## Getting Started

### Prerequisites

- Clarity language environment
- Vitest for running tests

### Installation

1. Clone the repository
2. Run tests using Vitest:
   \`\`\`
   npm test
   \`\`\`

## Usage

The contracts can be deployed to a Stacks blockchain network. Once deployed, they can be used to:

- Verify research institutions
- Create and manage research projects
- Allocate resources to projects
- Track project progress and milestones
- Manage research publications and peer reviews

## Testing

Tests are written using Vitest and can be found in the `tests` directory.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

