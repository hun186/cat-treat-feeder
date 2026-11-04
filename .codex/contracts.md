# Interface Contracts — CURRENT STATE

此專案目前**沒有 HTTP API、資料庫或 CLI 服務契約**；需要維護的是 CAD/實體機械尺寸與檔案輸出契約。

## CAD-001：食匙尺寸（Draft，依一般尺量）
- PP 大圓匙約 155 mm，全長；匙面約 43 × 50 mm；柄最窄約 9 mm、最寬約 14 mm、厚約 6 mm、略帶弧度。
- 尾端基準：最寬 35 mm、最窄 87 mm、匙頭交界 102 mm。
- 採購來源示例及餐後再利用界線詳見 `docs/spoon-sourcing-and-reuse.md`。
- **不是所有長度相同湯匙都相容**；更換來源必須重新量測局部柄尺寸。

## CAD-002：V1.14 卡扣／軌道（Draft）
- 前端內寬 9.5 mm／入口 8.7 mm；後端內寬 13.5 mm／入口 11.7 mm。
- 卡扣中心距 52 mm；基座兩端均有補強，前端倒鉤採較淺入口。
- 滑軌左右對稱，名義側向間隙每側 0.6 mm；底板與最前擋板共切面 x=141 mm。

## ART-001：模型檔與驗證
- 可編輯來源：`current/cat_treat_feeder_v1_14.scad`，以 `part` selector 輸出零件。
- 固定模型：`current/*.stl`，需為封閉、單一實體、正體積；應由 CI 驗證。
- 幾何檢查通過**不構成**實體安全、食品接觸或獸醫認證。
- 若源碼參數改變，需同步重新輸出 STL，維持 source/artifact 一致。
