mongoose = require 'mongoose'
URLSlugs = require 'mongoose-url-slugs'

# AccountingCategory
# ===========================================================================
# Groups payments by a significant description
AccountingCategory = new mongoose.Schema
  description: String

AccountingCategory.plugin URLSlugs 'description'

module.exports = mongoose.model 'AccountingCategory', AccountingCategory
