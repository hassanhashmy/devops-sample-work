## Project 2
This project is tested and pretty generic and can be used. 

### Project 2 Terraform

### Requirement: 
We need a solution which can help us to provision any envoronment with minimal changes and any part of whole infrastructre as per on demand basis. E.g if we need network layer only to be build so only network layer should be build. If wanted to build ec2 or bastion host or vpn on top of netwrok layer so project should allow us to create it without any issue. If we have to build whole infrastructure so it will build everything from scratch. Or if we need just few components or layers of infrastructure so it should allow us to do that by passing variables/parameter values true or false.

Terrafrom features used in this project.
- Backend State
- Import of exisiting resoruces
- Another Repo module included
- Count Feature
- Reusable Technique - We can either provision one layer of resources that we need or we can provision whole layer by using true and false