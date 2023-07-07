<template>
  <div id="user-list">
    <!-- app drawer -->
    <user-list-add-new
      v-model="isAddNewUserSidebarActive"
      @refetch-data="fetchUsers"
      :user-data="userData"
      :is-add="isAddAction"
      :role-options="roleOptions"
    ></user-list-add-new>

    <user-detail :is-bio-dialog-open.sync="isUserDetailDialogVisible" :user-id="userId"></user-detail>

    <!-- user total card -->
    <v-row class="mb-5">
      <v-col v-for="total in userTotalLocal" :key="total.value" cols="12" sm="6" md="3">
        <v-card>
          <v-card-text class="d-flex align-center justify-space-between pa-4">
            <div>
              <h2 class="font-weight-semibold mb-1">
                {{ total.total }}
              </h2>
              <span>{{ $t(total.title) }}</span>
            </div>

            <v-avatar
              :color="resolveUserTotalIcon(total.value).color"
              :class="`v-avatar-light-bg ${resolveUserTotalIcon(total.value).color}--text`"
            >
              <v-icon size="25" :color="resolveUserTotalIcon(total.value).color" class="rounded-0">
                {{ resolveUserTotalIcon(total.value).icon }}
              </v-icon>
            </v-avatar>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>

    <!-- list filters -->
    <v-card>
      <v-card-title> {{ $t('Search') }} &amp; {{ $t('Filter') }} </v-card-title>
      <v-row class="px-2 ma-0">
        <!-- role filter -->
        <v-col cols="12" sm="6">
          <v-select
            v-model="roleFilter"
            :placeholder="$t('Select Role')"
            :items="roleOptions"
            item-text="title"
            item-value="value"
            outlined
            clearable
            dense
            hide-details
          >
            <template v-slot:item="{ item }">
              <span>{{ $t(item.title) }}</span>
            </template>
          </v-select>
        </v-col>

        <!-- status filter -->
        <v-col cols="12" sm="6">
          <v-select
            v-model="statusFilter"
            :placeholder="$t('Select Status')"
            :items="statusOptions"
            item-text="title"
            item-value="value"
            outlined
            dense
            clearable
            hide-details
          >
            <template v-slot:item="{ item }">
              <span>{{ $t(item.title) }}</span>
            </template>
          </v-select>
        </v-col>
      </v-row>

      <v-divider class="mt-4"></v-divider>

      <!-- actions -->
      <v-card-text class="d-flex align-center flex-wrap pb-0">
        <!-- search -->
        <v-text-field
          v-model="searchQuery"
          :placeholder="$t('Search')"
          outlined
          hide-details
          dense
          class="user-search me-3 mb-4"
        >
        </v-text-field>

        <v-spacer></v-spacer>

        <div class="d-flex align-center flex-wrap">
          <v-btn color="primary" class="mb-4 me-3" @click.stop="addUserData">
            <v-icon>{{ icons.mdiPlus }}</v-icon>
            <span>{{ $t('Add New User') }}</span>
          </v-btn>
        </div>
      </v-card-text>

      <!-- table -->
      <v-data-table
        v-model="selectedRows"
        :headers="tableColumns"
        :items="userListTable"
        :options.sync="options"
        :server-items-length="totalUserListTable"
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
        <!-- name -->
        <template #[`item.fullName`]="{ item }">
          <div class="d-flex align-center">
            <v-avatar
              :color="item.avatarUrl ? '' : 'primary'"
              :class="item.avatarUrl ? '' : 'v-avatar-light-bg primary--text'"
              size="32"
            >
              <v-img v-if="item.avatarUrl" :src="item.avatarUrl"></v-img>
              <span v-else class="font-weight-medium">{{ avatarText(item.name) }}</span>
            </v-avatar>

            <div class="d-flex flex-column ms-3">
              <div
                @click.stop="openUserDetailDialog(item.id)"
                class="
                  text--primary
                  font-weight-semibold
                  text-truncate
                  cursor-pointer
                  text-decoration-none text-capitalize
                "
              >
                {{ item.name }}
              </div>
              <small>@{{ item.email.split('@')[0] }}</small>
            </div>
          </div>
        </template>

        <!-- role -->
        <template #[`item.role`]="{ item }">
          <div class="d-flex align-center">
            <v-avatar
              size="30"
              :color="resolveUserRoleVariant(item.role)"
              :class="`v-avatar-light-bg ${resolveUserRoleVariant(item.role)}--text me-3`"
            >
              <v-icon size="18" :color="resolveUserRoleVariant(item.role)">
                {{ resolveUserRoleIcon(item.role) }}
              </v-icon>
            </v-avatar>
            <span class="text-capitalize">{{ $t(`${item.role}`) }}</span>
          </div>
        </template>

        <!-- company id -->
        <template #[`item.companyName`]="{ item }">
          <span class="text-capitalize font-weight-semibold text--primary" v-if="item.company">{{ item.company.companyName }}</span>
        </template>

        <!-- status -->
        <template #[`item.status`]="{ item }">
          <v-chip
            small
            :color="resolveUserStatusVariant(item.status)"
            :class="`${resolveUserStatusVariant(item.status)}--text`"
            class="v-chip-light-bg font-weight-semibold text-capitalize"
          >
            {{ $t(`${item.status}`) }}
          </v-chip>
        </template>

        <!-- last login -->
        <template #[`item.lastSignInAt`]="{ item }">
          {{ item.lastSignInAt }}
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
              <v-list-item @click.stop="openUserDetailDialog(item.id)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiFileDocumentOutline }}
                  </v-icon>
                  <span>{{ $t('Details') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="editUserData(item)">
                <v-list-item-title>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiPencilOutline }}
                  </v-icon>
                  <span>{{ $t('Edit') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="updateUserStatus(item)">
                <v-list-item-title v-if="item.status === 'active'">
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiLockOutline }}
                  </v-icon>
                  <span>{{ $t('Deactivate') }}</span>
                </v-list-item-title>
                <v-list-item-title v-else>
                  <v-icon size="20" class="me-2">
                    {{ icons.mdiLockOpenVariantOutline }}
                  </v-icon>
                  <span>{{ $t('Deactivate') }}</span>
                </v-list-item-title>
              </v-list-item>

              <v-list-item @click.stop="deleteUserData(item)">
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
import {
  mdiSquareEditOutline,
  mdiDotsVertical,
  mdiPlus,
  mdiFileDocumentOutline,
  mdiPencilOutline,
  mdiTrashCanOutline,
  mdiLockOutline,
  mdiLockOpenVariantOutline,
} from '@mdi/js'
import store from '@/store'
import { onUnmounted, ref } from '@vue/composition-api'

// sidebar
import { avatarText } from '@core/utils/filter'
import UserListAddNew from './UserListAddNew.vue'
import UserDetail from './UserDetail.vue'
import userStoreModule from '@/store/modules/userStoreModule'

import useUsersList from './useUsersList'

export default {
  components: {
    UserListAddNew,
    UserDetail,
  },
  setup() {
    const USER_APP_STORE_MODULE_NAME = 'app-user'

    // Register module
    if (!store.hasModule(USER_APP_STORE_MODULE_NAME)) store.registerModule(USER_APP_STORE_MODULE_NAME, userStoreModule)

    // UnRegister on leave
    onUnmounted(() => {
      if (store.hasModule(USER_APP_STORE_MODULE_NAME)) store.unregisterModule(USER_APP_STORE_MODULE_NAME)
    })

    const {
      userListTable,
      tableColumns,
      searchQuery,
      roleFilter,
      statusFilter,
      totalUserListTable,
      loading,
      options,
      userTotalLocal,
      selectedRows,

      fetchUsers,
      resolveUserRoleVariant,
      resolveUserRoleIcon,
      resolveUserStatusVariant,
      resolveUserTotalIcon,
    } = useUsersList()

    const roleOptions = [
      { title: 'manager', value: 'imanager' },
      { title: 'client', value: 'client' },
      { title: 'projectManager', value: 'projectManager' },
      { title: 'developer', value: 'developer' },
      { title: 'superAdmin', value: 'superAdmin' },
    ]

    const statusOptions = [
      { title: 'pending', value: 'pending' },
      { title: 'active', value: 'active' },
      { title: 'inactive', value: 'inactive' },
    ]

    const isAddNewUserSidebarActive = ref(false)
    const isUserDetailDialogVisible = ref(false)
    const isAddAction = ref(true)

    const userData = ref({
      email: '',
      password: '',
      role: '',
      companyId: null,
    })

    const addUserData = () => {
      isAddAction.value = true
      isAddNewUserSidebarActive.value = true
    }

    const editUserData = item => {
      userData.value = item
      isAddAction.value = false
      isAddNewUserSidebarActive.value = true
    }

    const updateUserStatus = item => {
      const params = {
        status: item.status != 'active' ? 'active' : 'inactive',
      }
      console.log(params)
      store.dispatch('app-user/updateUser', [item.id, params]).then(() => {
        fetchUsers()
      })
    }

    const deleteUserData = (item) => {
      store
      .dispatch('app-user/deleteUser', {
        id: item.id
      })
      .then(() => {
        fetchUsers()
      })
      .catch(error => {
        console.log(error)
      })
    }


    const userId = ref(null)

    const openUserDetailDialog = id => {
      userId.value = id
      isUserDetailDialogVisible.value = true
    }

    return {
      userListTable,
      tableColumns,
      searchQuery,
      roleFilter,
      statusFilter,
      totalUserListTable,
      roleOptions,
      statusOptions,
      loading,
      options,
      userTotalLocal,
      isAddNewUserSidebarActive,
      isUserDetailDialogVisible,
      selectedRows,
      avatarText,
      resolveUserRoleVariant,
      resolveUserRoleIcon,
      resolveUserStatusVariant,
      resolveUserTotalIcon,
      fetchUsers,
      userData,
      addUserData,
      editUserData,
      updateUserStatus,
      deleteUserData,
      isAddAction,

      userId,

      openUserDetailDialog,

      // icons
      icons: {
        mdiSquareEditOutline,
        mdiFileDocumentOutline,
        mdiDotsVertical,
        mdiTrashCanOutline,
        mdiPencilOutline,
        mdiPlus,
        mdiLockOutline,
        mdiLockOpenVariantOutline,
      },
    }
  },
}
</script>

<style lang="scss">
@import '@core/preset/preset/apps/user.scss';
</style>
