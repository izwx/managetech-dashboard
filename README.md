# Managetech Dashboard

Managetech Dashboard is a web dashboard of project management software. Dashboard displays statistic and graphic data of the project collected by [Managetech Project Knowledgebase](https://github.com/izwx/managetech-project-knowledgebase). 

The users(Project Clients, Project Managers, Developers, etc) can manage their project and track the project progress through the dashboard.

The dashboard has been built on Ruby on Rails on the backend and Vue.js on the frontend.

## Installation

If you want to run Managetech Dashboard in production (or for evaluation), refer to our in-depth [installation guides](./INSTALLATION.md).

## Configuration

We use AWS S3 as the storage within the Rails app, so we need to configure S3 in the `.env` file. 
Open `/mangetech/.env` file and include the values to S3 variables.
```bash
S3_BUCKET=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
```

We have the [Managetech Project Knowledgebase](https://github.com/izwx/managetech-project-knowledgebase) that collects data from the various project resources and we use the Analyzer API to pull the data and synchronize the DB tables with Analyzer's data.
Update the `DATA_SERVER_URL` variable(Analyzer API URL) in the `.env` file. 

```bash
DATA_SERVER_URL=
```

For the Vue.js frontend, we include `VUE_APP_API_URL` variable representing API URL of the RoR backend. Open `/frontend/.env` file and include the values.

```bash
VUE_APP_BASE_URL=
VUE_APP_API_URL=
```

## Usage

We included additional documents for developer's convenience to help them understand better of the Managetech Dashboard.

- [Aggregate Content and User Roles](./AGGREGATECONTENT.md)
- [Aggregate Timing and Batches](./AGGREGATETIMING.md)
- [DB Table Definition](./TABLEDEFINITION.md)



## Contribute
We welcome issues, questions, and pull requests. Don't hesitate to simply [contact us](http://managetech.io) if you have questions.

## License
`Managetech Dashboard` is under the terms of the [GNU Affero General Public License](https://www.gnu.org/licenses/agpl-3.0.html).
Please refer to [LICENSE](/LICENSE.md) for the full terms.

## Contact
Here you can find our [contact information](http://managetech.io). If you are interested in development or have general questions, feel free to also join our [community discussion forums](http://managetech.io).
