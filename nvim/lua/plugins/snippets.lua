return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    
    -- Load existing snippets from friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    
    -- Custom XSLT snippets
    ls.add_snippets("xslt", {
      s("xsl:template", {
        t('<xsl:template match="'),
        i(1, "pattern"),
        t('">'),
        t({"", "  "}),
        i(2, "<!-- content -->"),
        t({"", "</xsl:template>"}),
      }),
      
      s("xsl:for-each", {
        t('<xsl:for-each select="'),
        i(1, "xpath"),
        t('">'),
        t({"", "  "}),
        i(2, "<!-- content -->"),
        t({"", "</xsl:for-each>"}),
      }),
      
      s("xsl:if", {
        t('<xsl:if test="'),
        i(1, "condition"),
        t('">'),
        t({"", "  "}),
        i(2, "<!-- content -->"),
        t({"", "</xsl:if>"}),
      }),
      
      s("xsl:value-of", {
        t('<xsl:value-of select="'),
        i(1, "xpath"),
        t('"/>'),
      }),
      
      s("xsl:variable", {
        t('<xsl:variable name="'),
        i(1, "varname"),
        t('" select="'),
        i(2, "value"),
        t('"/>'),
      }),
    })
    
    -- Custom XML snippets
    ls.add_snippets("xml", {
      s("xml:comment", {
        t("<!-- "),
        i(1, "comment"),
        t(" -->"),
      }),
      
      s("xml:cdata", {
        t("<![CDATA["),
        i(1, "content"),
        t("]]>"),
      }),
    })
    
    -- Edit snippets keybinding
    vim.keymap.set("n", "<leader>se", function()
      require("luasnip.loaders").edit_snippet_files()
    end, { desc = "Edit snippets" })
  end,
}