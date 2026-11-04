# Project Profile — CURRENT STATE

- 初始化狀態：**INITIALIZED**
- 最後查證：2026-11-04；GitHub main、V1.14 SCAD/STL、README、實驗歷程及使用者量測記錄
- 專案：Cat Treat Feeder（貓條餵食器）

## 一句話目的
以**可重複使用的 3D 列印擠壓本體＋個別替換的商用 PP 湯匙**餵貓條，在不同貓咪／不同貓群之間減少食器共用造成的交叉污染機會。

## 使用情境
- 多貓互動、收容／送養空間、一般居家餵食；兒童須成人全程監督。
- 輸入：貓條軟袋、尺寸吻合的普通 PP 大圓匙；輸出：進入湯匙中的肉泥。
- 3D 列印零件避免與肉泥、貓舌直接接觸；必要時更換食匙並清潔本體。
- 可以新購湯匙，也可能清洗餐後留下的同款一般 PP 圓匙；跨貓群優先未使用過的新匙及場所 SOP。

## 技術與入口
- OpenSCAD：`current/cat_treat_feeder_v1_14.scad`；名義零件：底座、滑塊、前端試片、雙點連體試片。
- 對應 ASCII STL：`current/*.stl`；實驗歷程：`docs/development-history.md`。
- Python 3.11 + trimesh：`scripts/validate_stl.py`；GitHub Actions：`.github/workflows/cad-stl-check.yml`。
- 主要文件：`README.md`、`docs/measurements.md`、`docs/printing-and-fit.md`、`docs/spoon-sourcing-and-reuse.md`。
- 暫無執行中的服務、資料庫、外部 API 或使用者機密設定。

## 已知尺寸與限制
- PP 大圓匙全長約 155 mm，匙頭寬 43 mm／長約 50 mm，匙柄最窄 9 mm、最寬 14 mm、厚約 6 mm，略帶弧度。
- 尾端起算最寬 35 mm、最窄 87 mm、匙頭交界 102 mm；前後卡扣中心 52 mm。
- V1.14：前內寬 9.5 mm／入口 8.7 mm；後內寬 13.5 mm／入口 11.7 mm；左右對稱滑軌；前端 x=141 mm 共切面。
- 上述尺寸使用一般尺量測，**不是正式 3D 掃描或公差認證**。
- 軟體幾何檢查可通過，但無法取代實體卡扣壽命、餵食安全、食安與消毒驗證。

## 交接
詳見 `.codex/memory.md` 與 `.codex/backlog.md`。其他尺寸或湯匙變更必須先測試小試片，不能靠硬壓裝配。
