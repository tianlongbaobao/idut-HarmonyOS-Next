import { relationalStore } from '@kit.ArkData';

@Concurrent
export async function queryall(context: Context): Promise<Array<relationalStore.ValuesBucket>> {
  const CONFIG: relationalStore.StoreConfig= {
    name: 'message.db', // 数据库文件名
    securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
    encrypt: false,
    isReadOnly: false
  };

  // 默认数据库文件路径为 context.databaseDir + rdb + StoreConfig.name
  let store: relationalStore.RdbStore = await relationalStore.getRdbStore(context, CONFIG);

  // 获取结果集
  let predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates("NOTICE");
  let resultSet = await store.query(predicates);  // 查询所有数据
  console.info(`Query data successfully! row count:${resultSet.rowCount}`);
  let index = 0;
  let result = new Array<relationalStore.ValuesBucket>(resultSet.rowCount)
  resultSet.goToFirstRow()
  do {
    result[index++] = resultSet.getRow()
  } while (resultSet.goToNextRow());
  resultSet.close();
  return result
}

@Concurrent
export async function clearall(context: Context) {
  const CONFIG: relationalStore.StoreConfig= {
    name: 'Notice.db', // 数据库文件名
    securityLevel: relationalStore.SecurityLevel.S3, // 数据库安全级别
    encrypt: false,
    customDir: 'noticedata', // 可选参数，数据库自定义路径。数据库将在如下的目录结构中被创建：context.databaseDir + '/rdb/' + customDir，其中context.databaseDir是应用沙箱对应的路径，'/rdb/'表示创建的是关系型数据库，customDir表示自定义的路径。当此参数不填时，默认在本应用沙箱目录下创建RdbStore实例。
    isReadOnly: false
  };

  // 默认数据库文件路径为 context.databaseDir + rdb + StoreConfig.name
  await relationalStore.deleteRdbStore(context, CONFIG);
  console.info(`Delete Store.db successfully!`);
}