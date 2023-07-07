<template>
  <div id="log-list">
    <!-- search card -->
    <v-card>
      <!-- actions -->
      <v-card-text class="d-flex align-center flex-wrap pb-0">
        <!-- search -->
        <v-text-field
          v-model="searchQuery"
          :placeholder="$t('Search')"
          outlined
          hide-details
          dense
          class="log-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>
      </v-card-text>

      <!-- table -->
      <v-data-table
        :headers="tableColumns"
        :items="logListTable"
        :options.sync="options"
        :server-items-length="totalLogListTable"
        :loading="loading"
        hide-default-header
        :footer-props="{
          showFirstLastPage: true,
          'items-per-page-text': $t('Rows per page'),
        }"
      >
        <template #header="{ props: { headers } }">
          <thead class="v-data-table-header">
            <tr>
              <th
                v-for="header in headers"
                :key="header.value"
                class="text-uppercase"
                :class="{ 'text-right': header.align == 'right' }"
                scope="col"
              >
                {{ $t(header.text) }}
              </th>
            </tr>
          </thead>
        </template>
        <!-- company name -->
        <template #[`item.company_name`]="{ item }">
          <div class="d-flex align-center">
            <span class="text--primary">{{ item.company.companyName }}</span>
          </div>
        </template>

        <!-- project name -->
        <template #[`item.project_name`]="{ item }">
          <span class="text--primary">{{ item.project.projectName }}</span>
        </template>

        <!-- module -->
        <template #[`item.module`]="{ item }">
          <span class="text--primary">{{ item.module }}</span>
        </template>

        <!-- batch type -->
        <template #[`item.batch_type`]="{ item }">
          <v-chip
            small
            :color="statusColor[item.batchType]"
            :class="`${statusColor[item.batchType]}--text`"
            class="v-chip-light-bg font-weight-semibold text-capitalize"
          >
            {{ item.batchType }}
          </v-chip>
        </template>

        <!-- content -->
        <template #[`item.content`]="{ item }">
          <span class="text--primary">{{ item.content }}</span>
        </template>

        <!-- start datetime -->
        <template #[`item.start_datetime`]="{ item }">
          <span class="text--primary">{{ moment(item.startDatetime).format('YYYY-MM-DD HH:mm:ss') }}</span>
        </template>

        <!-- end datetime -->
        <template #[`item.end_datetime`]="{ item }">
          <span class="text--primary">{{ moment(item.endDatetime).format('YYYY-MM-DD HH:mm:ss') }}</span>
        </template>

        <!-- actions -->
        <template #[`item.actions`]="{ item }">
          <v-menu bottom left>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on">
                <v-icon>{{ icons.mdiDotsVertical }}</v-icon>
              </v-btn>
            </template>

            <v-list>
              <v-list-item @click.stop="deleteLogData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiTrashCanOutline }}
                  </v-icon>
                  <span>{{ $t('Delete') }}</span>
                </v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </template>
      </v-data-table>
    </v-card>
  </div>
</template>

<script>
// eslint-disable-next-line object-curly-newline
import store from '@/store'
import { onUnmounted } from '@vue/composition-api'
import moment from 'moment'

import { mdiTrashCanOutline, mdiDotsVertical } from '@mdi/js'

// sidebar
import logStoreModule from '@/store/modules/logStoreModule'
import useLogsList from './useLogList'

export default {
  setup() {
    const statusColor = {
      /* eslint-disable key-spacing */
      info: 'info',
      warning: 'warning',
      error: 'error',
      /* eslint-enable key-spacing */
    }

    const LOG_STORE_MODULE_NAME = 'app-log'

    // Register module
    if (!store.hasModule(LOG_STORE_MODULE_NAME)) store.registerModule(LOG_STORE_MODULE_NAME, logStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(LOG_STORE_MODULE_NAME)) store.unregisterModule(LOG_STORE_MODULE_NAME)
    })

    const { logListTable, tableColumns, totalLogListTable, searchQuery, loading, options, fetchLogs } = useLogsList()

    const deleteLogData = item => {
      store
        .dispatch('app-log/deleteLog', {
          id: item.id,
        })
        .then(() => {
          fetchLogs()
        })
        .catch(error => {
          console.log(error)
        })
    }

    return {
      statusColor,
      logListTable,
      tableColumns,
      searchQuery,
      totalLogListTable,
      loading,
      options,
      moment,
      //Methods
      deleteLogData,
      // icons
      icons: {
        mdiDotsVertical,
        mdiTrashCanOutline,
      },
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/log.scss';
</style>
