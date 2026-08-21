local function readFile(filePath)
  local file = io.open(filePath, "r")

  if not file then
    return nil
  end

  local contents = file:read("*all")

  file:close()

  return contents;
end

local function read_nearest_ts_config()
  local rootDir = vim.fs.root(0, { 'tsconfig.json' })

  if not rootDir then
    return nil
  end

  local tsConfig = rootDir .. "/tsconfig.json"
  local contents = readFile(tsConfig)
  local manifest = readFile(rootDir .. "/package.json")

  if not contents then
    return nil
  end

  if not manifest then
    return nil
  end


  -- BUG:
  --   this does not follow "extends" or global tsconfigs if a "one tsconfig.json"
  --   is used.
  local isGlintV1 = string.find(contents, '"glint"')
  local hasGlintPlugin = string.find(manifest, "@glint/ember%-tsc")
  -- TypeScript 7 content mappers (e.g. ember-content-mapper):
  -- tsconfig.json declares the mappers directly, and TypeScript's own LSP
  -- handles gts/gjs, so neither ts_ls nor glint should attach.
  local hasContentMappers = string.find(contents, '"contentMappers"')

  return {
    isGlintV1 = not not isGlintV1,
    isGlintV2 = not not hasGlintPlugin,
    isContentMapper = not not hasContentMappers,
    rootDir = rootDir,
  };
end

-- See:
-- :help lspconfig
-- search for ROOT DIRECTORY DETECTION
local function is_glint_project(bufnr, onDir)
  local result = read_nearest_ts_config()

  if not result then
    return nil
  end

  if (result.isContentMapper) then
    return nil
  end

  if (result.isGlintV2) then
    return nil
  end

  if (not result.isGlintV1) then
    return nil
  end

  onDir(result.rootDir)
end

local function is_ts_project(bufnr, onDir)
  local result = read_nearest_ts_config()

  if not result then
    return nil
  end

  if (result.isContentMapper) then
    return nil
  end

  if (result.isGlintV2) then
    return onDir(result.rootDir)
  end

  if (result.isGlintV1) then
    return nil
  end

  return onDir(result.rootDir)
end

local function is_content_mapper_project(bufnr, onDir)
  local result = read_nearest_ts_config()

  if not result then
    return nil
  end

  if (not result.isContentMapper) then
    return nil
  end

  return onDir(result.rootDir)
end

return {
  is_glint_v1_project = is_glint_project,
  is_ts_project = is_ts_project,
  is_content_mapper_project = is_content_mapper_project,
}
