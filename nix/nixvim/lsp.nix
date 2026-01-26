{ ... }:
{
  programs.nixvim.plugins.lsp = {
      enable = true;
      servers = {
        # pyright = {
        #     enable = true;
        #     onNewConfig = {
        #       __raw = ''
        #         function(new_config, new_root_dir)
        #           new_config.settings.python.pythonPath = vim.fn.exepath("python")
        #         end
        #       '';
        #     };
        #   };
        # ty = {
        #   enable = true;
        # };
        # ruff = {
        #   enable = true;
        # };
        basedpyright.enable = true;
        ruff.enable = true;
      };
  };
}
