<template>
  <div id="skill-list">
    <!-- app drawer -->
    <skill-list-add-new
      v-model="isAddNewSkillSidebarActive"
      @refetch-data="fetchSkills"
      :skill-data="skillData"
      :is-add="isAddAction"
    ></skill-list-add-new>

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
          class="skill-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addSkillData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New Skill') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="skillListTable"
        :options.sync="options"
        :server-items-length="totalSkillListTable"
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
        <!-- skill name -->
        <template #[`item.skill_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.skillName }}
            </div>
            <span class="text--secondary text-sm">#{{ item.id }}</span>
          </div>
        </template>

        <!-- project name -->
        <template #[`item.project_name`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.project.projectName || '' }}
            </div>
          </div>
        </template>

        <!-- creater name -->
        <template #[`item.creater`]="{ item }">
          <div class="d-flex flex-column ms-3">
            <div class="text--primary font-weight-semibold text-truncate text-decoration-none">
              {{ item.creater.email || '' }}
            </div>
            <div class="d-flex align-center">
              <v-chip
                small
                :color="resolveUserRoleVariant(item.creater.role)"
                :class="`${resolveUserRoleVariant(item.creater.role)}--text`"
                class="v-chip-light-bg font-weight-semibold text-capitalize"
                v-if="item.creater.role"
              >
                <span class="text-xs">{{ $t(`${item.creater.role}`) }}</span>
              </v-chip>
            </div>
          </div>
        </template>

        <!-- actions -->
        <template #[`item.actions`]="{ item }">
          <v-menu bottom right>
            <template v-slot:activator="{ on, attrs }">
              <v-btn icon v-bind="attrs" v-on="on">
                <v-icon>{{ icons.mdiDotsVertical }}</v-icon>
              </v-btn>
            </template>

            <v-list>
              <v-list-item @click.stop="editSkillData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>
              <v-list-item @click.stop="deleteSkillData(item)">
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
import { onUnmounted, ref } from '@vue/composition-api'
import store from '@/store'
import skillStoreModule from '@/store/modules/skillStoreModule'

// sidebar
import { avatarText } from '@core/utils/filter'
import SkillListAddNew from './SkillListAddNew.vue'
// eslint-disable-next-line object-curly-newline
import { mdiDotsVertical, mdiPlus, mdiPencilOutline, mdiTrashCanOutline } from '@mdi/js'

import useSkillsList from './useSkillsList'

export default {
  components: {
    SkillListAddNew,
  },
  setup() {
    const SKILL_STORE_MODULE_NAME = 'app-skill'

    // Register module
    if (!store.hasModule(SKILL_STORE_MODULE_NAME)) store.registerModule(SKILL_STORE_MODULE_NAME, skillStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(SKILL_STORE_MODULE_NAME)) store.unregisterModule(SKILL_STORE_MODULE_NAME)
    })

    const {
      skillListTable,
      tableColumns,
      searchQuery,
      totalSkillListTable,
      loading,
      options,
      selectedRows,

      fetchSkills,
      resolveUserRoleVariant,
      resolveUserRoleIcon,
    } = useSkillsList()

    const skillData = ref({
      skillName: '',
      projectId: null,
    })

    const isAddAction = ref(true)

    const addSkillData = () => {
      isAddAction.value = true
      isAddNewSkillSidebarActive.value = true
    }

    const editSkillData = item => {
      skillData.value = item
      isAddAction.value = false
      isAddNewSkillSidebarActive.value = true
    }

    const deleteSkillData = item => {
      store
        .dispatch('app-skill/deleteSkill', { id: item.id })
        .then(response => {
          fetchSkills()
        })
        .catch(error => {
          alert("Can't delete the skill.")
        })
    }

    const isAddNewSkillSidebarActive = ref(false)

    const getTeamNames = teams => {
      return teams.map(team => team.teamName)
    }

    return {
      skillListTable,
      tableColumns,
      searchQuery,
      totalSkillListTable,
      loading,
      options,
      isAddNewSkillSidebarActive,
      selectedRows,
      avatarText,
      fetchSkills,
      resolveUserRoleVariant,
      resolveUserRoleIcon,

      getTeamNames,
      skillData,
      isAddAction,
      addSkillData,
      editSkillData,
      deleteSkillData,

      // icons
      icons: {
        mdiDotsVertical,
        mdiPencilOutline,
        mdiPlus,
        mdiTrashCanOutline,
      },
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/skill.scss';
</style>
